From: Devesh Agrawal <devesh.agrawal@gmail.com>
Subject: Re: Newbie question about fragmentation and the PRE_ROUTING hook
Date: Sat, 26 Mar 2005 05:02:02 +0530
Message-ID: <db01ab350503251532128566c@mail.gmail.com>
References: <42403008.9070006@cardvn.net> <42444A4A.5090308@cardvn.net>
	<db01ab3505032511079d11ea4@mail.gmail.com>
Reply-To: Devesh Agrawal <devesh.agrawal@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <db01ab3505032511079d11ea4@mail.gmail.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hi,
Just to add some more info:
I wrote a simple src routing protocol , which adds a new hdr b/w the
ip and the tcp headers. I fragment a packet, such that each fragment
has the ip and my header (so that I decide the route for every frag).
However if I allow the kernel to reassemble my fragments it will screw
things up for me as it does not know anything about my header. Hence I
want to process each of the fragments in pre route as it is (basically
I remove my header and pass it up to local_in, where it can be
defragged in ip_local_deliver before calling my local in hander).
I have given NF_IP_PRE_FIRST priority to my pre route handler, but
still it is getting some screwed up reassembled packet, as probably
Netfilter is trying to reassemble my packet and hence messing it up.
I read up that conntrack defrags the packet, but it does so with a
lower priority (higher value) than NF_IP_PRE_FIRST, inspite of all
this, I do not know why my pre route handler is getting a defragged
packet. Any idea of what I am missing out.
PS: My sender explicitly frags a packet if its size is greater than
some value (currently set to 500). Hence I am sure that I am
generating those fragments. I will be greatful for any insight into
this problem.
Regards,
Devesh Agrawal

On Sat, 26 Mar 2005 00:37:41 +0530, Devesh Agrawal
<devesh.agrawal@gmail.com> wrote:
> Hi,
> I have a very basic question about netfilter and IP fragments. My
> understanding is that the pre routing hook gets the fragmented packet
> , which is later in defragged in local in in the ip_local_input funx.
> ie If I print the skb in pre route hook, I shall get the individual
> frags, whereas in local in hook I would get the complete packet. Is
> this absolutely correct ?
> Am I gettting the right picture or is there anything else that I should know?
> I would be grateful if someone could clear my doubt.
> Sincerely,
> Devesh Agrawal
> 


-- 
Devesh Agrawal
4th year Dual Degree.
Dept of CSE 
Indian Institute of Technology , Madras
Room No . 309 , Alakananda Hostel 
Chennai 600036 ,India
Ph : +91 9382102431
