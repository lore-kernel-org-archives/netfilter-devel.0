From: Scott MacKay <scottmackay@yahoo.com>
Subject: Extending userspace verdict messages
Date: Thu, 8 Jul 2004 09:47:01 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040708164701.15541.qmail@web13902.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hiyas,
   I wanted to extend the verdict messages
(ipq_verdict_msg) to support passing additional
alterations from the userspace application to the
ip_queue module.  
To retain some compatibility, I thought the best thing
to do is to augment the ipq_peer_msg structure instead
of directly replacing the ipq_verdict_msg.
Currently it is:

typedef struct ipq_peer_msg {
        union {
                ipq_verdict_msg_t verdict;
                ipq_mode_msg_t mode;
        } msg;
} ipq_peer_msg_t;

I added in a new line after the mode declaration to
include my own new structure:

typedef struct ipq_peer_msg {
        union {
                ipq_verdict_msg_t verdict;
                ipq_mode_msg_t mode;
                ipq_everdict_msg_t everdict;
        } msg;
} ipq_peer_msg_t;

I augmented the IPQM_ defines for my message style. 
Currently, I do not use the new verdict, so I did not
generate any support code to call it from userspace or
to handle the case from ip_queue' I wanted to update
the structure and insure the existing process works
OK.
As a note, the everdict is bigger than verdict, so
chances are the union grew in size.  I copied the
updated ip_queue.h to the /usr area (for iptables),
made and installed modules, cleaned and
rebuilt/reinstalled iptables (1.2.11), and then
cleaned and rebuilt my application.  For some reason,
though, when my app accepts the packets
(ipq_set_verdict), they never make it to their
destination.  
I went to the extend of actually doing a make mrproper
and the rebuilding the entire kernel again for
freshness, though I believe the verdict is exclusively
used by ip_queue.  If I go in and take out the line
from the union, it works again.  Is there a piece that
I am forgetting to recompile/reinstall?

-Scott




		
__________________________________
Do you Yahoo!?
Yahoo! Mail - 50x more storage than other providers!
http://promotions.yahoo.com/new_mail
