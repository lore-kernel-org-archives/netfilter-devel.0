From: Scott MacKay <scottmackay@yahoo.com>
Subject: Re: Extending userspace verdict messages [ + solution,long ]
Date: Thu, 8 Jul 2004 12:51:20 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040708195120.53830.qmail@web13903.mail.yahoo.com>
References: <20040708164701.15541.qmail@web13902.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20040708164701.15541.qmail@web13902.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I think I identified my own problem...
The problem comes because the ipq_verdict_msg_t
message is not the largest message.  ipq_verdict_msg_t
ends with a :

unsigned char payload[0];

This is done, I am guessing, because the data
immediately following it is the payload during the
peer message packing, basically stacking the header
and payload contents back to back.  The issue is that
my new verdict message in the union is larger, meaning
there is a gap between the ipq_verdict_msg_t's payload
and the packed up payload.  The result is that I get
garbage space at the start of ipq_verdict_msg_t's
payload[] variable, corrupting packet contents.  I am
guessing another layer tosses the crap packet out.  
I confirmed this by adding my data items into the
existing ipq_verdict_msg_t contents and it worked
fine.  

This is the solution that I found which works.
 
The key issue is that the packing of the message to
ip_queue adds in space between the ipq_verdict_msg_t
and the start of the payload contents.  This is done
is libipq's ipq_set_verdict().  The packaging is done
by identifying vectors of data and data lengths. 
Messages have at least 2 components:  a nlmsghdr
header and a ipq_peer_msg_t.  The issue is that it
packs the header as follows ( ipq_peer_msg_t pm;
struct iovec iov[3];)

        iov[1].iov_base = &pm;
        iov[1].iov_len = sizeof(pm);
        tlen = sizeof(nlh) + sizeof(pm);

This means the size of this chunk is *always* the
largest of the union.  (as a note ipq_set_mode does
the same for it's tiny mode message).
My solution:  Replace the following lines:
        iov[1].iov_base = &pm;
        iov[1].iov_len = sizeof(pm);
        tlen = sizeof(nlh) + sizeof(pm);
With:
        iov[1].iov_base = &pm;
        iov[1].iov_len = sizeof(ipq_verdict_msg_t);
        tlen = sizeof(nlh) +
sizeof(ipq_verdict_msg_t);

What this does is indicate the size of the [1] chunk
is only sizeof(ipq_verdict_msg_t) bytes big, instead
of the whole union.  This trims out any fat the rest
of the union has and places the payload contents back
to back with the header, making ipq_verdict_msg_t's
payload field valid again.  Since ipq_set_verdict() is
used exclusively to pass down a ipq_verdict_msg_t
structure, I do not see any issues with this change.

-Scott






--- Scott MacKay <scottmackay@yahoo.com> wrote:
> Hiyas,
>    I wanted to extend the verdict messages
> (ipq_verdict_msg) to support passing additional
> alterations from the userspace application to the
> ip_queue module.  
> To retain some compatibility, I thought the best
> thing
> to do is to augment the ipq_peer_msg structure
> instead
> of directly replacing the ipq_verdict_msg.
> Currently it is:
> 
> typedef struct ipq_peer_msg {
>         union {
>                 ipq_verdict_msg_t verdict;
>                 ipq_mode_msg_t mode;
>         } msg;
> } ipq_peer_msg_t;
> 
> I added in a new line after the mode declaration to
> include my own new structure:
> 
> typedef struct ipq_peer_msg {
>         union {
>                 ipq_verdict_msg_t verdict;
>                 ipq_mode_msg_t mode;
>                 ipq_everdict_msg_t everdict;
>         } msg;
> } ipq_peer_msg_t;
> 
> I augmented the IPQM_ defines for my message style. 
> Currently, I do not use the new verdict, so I did
> not
> generate any support code to call it from userspace
> or
> to handle the case from ip_queue' I wanted to update
> the structure and insure the existing process works
> OK.
> As a note, the everdict is bigger than verdict, so
> chances are the union grew in size.  I copied the
> updated ip_queue.h to the /usr area (for iptables),
> made and installed modules, cleaned and
> rebuilt/reinstalled iptables (1.2.11), and then
> cleaned and rebuilt my application.  For some
> reason,
> though, when my app accepts the packets
> (ipq_set_verdict), they never make it to their
> destination.  
> I went to the extend of actually doing a make
> mrproper
> and the rebuilding the entire kernel again for
> freshness, though I believe the verdict is
> exclusively
> used by ip_queue.  If I go in and take out the line
> from the union, it works again.  Is there a piece
> that
> I am forgetting to recompile/reinstall?
> 
> -Scott
> 
> 
> 
> 
> 		
> __________________________________
> Do you Yahoo!?
> Yahoo! Mail - 50x more storage than other providers!
> http://promotions.yahoo.com/new_mail
> 
> 



	
		
__________________________________
Do you Yahoo!?
New and Improved Yahoo! Mail - 100MB free storage!
http://promotions.yahoo.com/new_mail 
