From: =?iso-8859-1?q?Daryl=20ong?= <yjong1977extramail@yahoo.com.sg>
Subject: Re: Help in netfilter kernel module
Date: Thu, 16 Oct 2003 17:26:49 +0800 (CST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031016092649.35565.qmail@web13103.mail.yahoo.com>
References: <Pine.LNX.4.44.0310160911240.6046-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: multipart/alternative; boundary="0-226053798-1066296409=:35529"
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0310160911240.6046-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

--0-226053798-1066296409=:35529
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit

Hi Henrik,
               Thanks for replying my mail.  I think you are right as i have test it with an application using PF_PACKETS.  So is it any way i can go around this problem.  Thank you in advance.
 
Regards, 
Daryl

Henrik Nordstrom <hno@marasystems.com> wrote:
On Thu, 16 Oct 2003, Daryl ong wrote:

> i am a new developer in this netfilter module. i am developing a
> kernel module on a rehat linux 8 and using iptables v1.2.6a. i came
> across a problem when i want to kfree_skb(skb).

> i have try to use NF_DROP to drop the packet if it doesnt match what i
> want to filter away. But as netfilter currently didnt filter for
> PF_PACKET, my packet is able to go up to application layer. So i
> intended to use kfree_skb but encounter the error. Please tell me if
> there is any solutions. Thank you.

If you want to drop a packet from netfilter you MUST NF_DROP it. Freeing
it with kfree_skb won't help, and if done carelessly will really crash
things as the kernel expects the skb reference to be there.

I do not think you can filter PF_PACKET sockets using netfilter. These get 
the packet very early in the processing chain while netfilter operates 
at the IPv4/IPv6 layers.

In netfilter you can

a) Drop the packet via NF_DROP. This also terminates the session if you
are using conntrack.

b) Replace/modify the packet, making further processing see another
packet. See for example ipt_TCPMSS.c for a simple example of how to
replace a packet (this is a iptables module, but the same rules in how to
replace/modify a packet applies to a netfilter module)

c) Steal the packet, stopping further processing of this packet without 
terminating the session. (NF_STOLEN verdict)

In all three cases I think the original packet is still sent to PF_PACKET 
sockets for the reason outlined above.

Regards
Henrik

 The New Yahoo! Search
- Now with image search!
--0-226053798-1066296409=:35529
Content-Type: text/html; charset=iso-8859-1
Content-Transfer-Encoding: 8bit

<DIV>Hi Henrik,</DIV>
<DIV>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Thanks for replying my mail.&nbsp; I think you are right as i have test it with an application using PF_PACKETS.&nbsp; So is it any way i can go around this problem.&nbsp; Thank you in advance.</DIV>
<DIV>&nbsp;</DIV>
<DIV>Regards, </DIV>
<DIV>Daryl<BR><BR><B><I>Henrik Nordstrom &lt;hno@marasystems.com&gt;</I></B> wrote:</DIV>
<BLOCKQUOTE class=replbq style="PADDING-LEFT: 5px; MARGIN-LEFT: 5px; BORDER-LEFT: #1010ff 2px solid">On Thu, 16 Oct 2003, Daryl ong wrote:<BR><BR>&gt; i am a new developer in this netfilter module. i am developing a<BR>&gt; kernel module on a rehat linux 8 and using iptables v1.2.6a. i came<BR>&gt; across a problem when i want to kfree_skb(skb).<BR><BR>&gt; i have try to use NF_DROP to drop the packet if it doesnt match what i<BR>&gt; want to filter away. But as netfilter currently didnt filter for<BR>&gt; PF_PACKET, my packet is able to go up to application layer. So i<BR>&gt; intended to use kfree_skb but encounter the error. Please tell me if<BR>&gt; there is any solutions. Thank you.<BR><BR>If you want to drop a packet from netfilter you MUST NF_DROP it. Freeing<BR>it with kfree_skb won't help, and if done carelessly will really crash<BR>things as the kernel expects the skb reference to be there.<BR><BR>I do not think you can filter PF_PACKET sockets using netfilter. Thes
 e get
 <BR>the packet very early in the processing chain while netfilter operates <BR>at the IPv4/IPv6 layers.<BR><BR>In netfilter you can<BR><BR>a) Drop the packet via NF_DROP. This also terminates the session if you<BR>are using conntrack.<BR><BR>b) Replace/modify the packet, making further processing see another<BR>packet. See for example ipt_TCPMSS.c for a simple example of how to<BR>replace a packet (this is a iptables module, but the same rules in how to<BR>replace/modify a packet applies to a netfilter module)<BR><BR>c) Steal the packet, stopping further processing of this packet without <BR>terminating the session. (NF_STOLEN verdict)<BR><BR>In all three cases I think the original packet is still sent to PF_PACKET <BR>sockets for the reason outlined above.<BR><BR>Regards<BR>Henrik<BR></BLOCKQUOTE><p><img src=http://sg.yimg.com/i/sg/icons/16/search.gif> <b><a 
href="http://sg.rd.yahoo.com/mail/tagline/?http://sg.search.yahoo.com" 
target=_blank>The New Yahoo! Search</a></b><br><small>- Now with <a href="http://sg.rd.yahoo.com/mail/tagline/?http://sg.search.yahoo.com/images" target=_blank>image search</a>!</small>
--0-226053798-1066296409=:35529--
