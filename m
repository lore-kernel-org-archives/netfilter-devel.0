From: "hMax Roth" <mroth2002@hotmail.com>
Subject: RE: Question about mac addresses in IP hook.,
Date: Sat, 14 Sep 2002 07:18:06 +0000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <F238tv3x6BfNLP8NLnI0001196f@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Cc: DanE@aiinet.com
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

Thanks for the response.
On the NF_IP_PRE_ROUTING I can get the mac header without a problem (what a 
relief! Thanks for the help, it really helped a lot) Basically, it's always 
14 bytes before the data pointer or on the .mac union.  However, the 
outbound hook, the mac address pointer is still randomly NULL and pointing 
to strange data! I can't understand it.  The code looks something like this

<in NF_IP_LOCAL_OUToutbound hook>

if ((*pkb)->mac.ethernet)
	PrintPacket((*pskb)->mac.raw, 14);
I	<or>
	PrintData((*pskb)->mac.ehernet->h_source, 6)
else
	Printk(“Ethernet header is NULL”);

(h_source points to the source array in the Ethernet header struct.  I’m not 
sure what the exact name is)
If I sniff the connect, I can see the packets coming out correctly, but my 
hook keeps seeing NULL?
I wonder if it’s a bug.  I know that the Ethernet driver is supposed to 
populate the Ethernet header pointer on the inbound packets, who sets them 
on the outbound? Any ideas?



>From: "Eble, Dan" <DanE@aiinet.com>
>To: 'hMax Roth' <mroth2002@hotmail.com>
>Subject: RE: Question about mac addresses in IP hook.,
>Date: Fri, 13 Sep 2002 09:08:32 -0400
>
>Have you examined the source for the kernel MAC matcher module in
>net/ipv4/netfilter/ipt_mac.c?  What device drivers are you using for your
>network interfaces?  Could there be bug in one of them?
>
>If you find an answer to this problem, I am interested in hearing it as
>well.  I haven't started testing MAC filters in my system yet, but when I
>do, I'll let you know if I run into any problems like this.
>
>--
>Dan Eble <dane@aiinet.com>           _____  .
>Applied Innovation Inc.             |  _  |/|
>Dublin, OH  43017-3271              | |_| | |
>614-923-1185 or 800-247-9482 x2051  |__/|_|_|
>
> > -----Original Message-----
> > From: hMax Roth [mailto:mroth2002@hotmail.com]
> > Sent: Thursday, September 12, 2002 11:04 PM
> > To: netfilter-devel@lists.netfilter.org
> > Subject: Question about mac addresses in IP hook.,
> >
> >
> > Hello,
> >    I'm having a tough time working on a tunnel type protocol
> > for Linux.  I'm
> > using netfilter and have registered my call back for the
> > first imbound hook.
> > I'm able to see the IP headers + UDP + etc, but I cannot get
> > at the mac
> > address.  I've tried reading the (*skb)->mac.ethernet but the
> > pointer comes
> > out NULL sometimes!? I thought that since because I'm
> > registering on the IP
> > hook, I'm gaurenteed to have an IP packet (with mac address
> > field filled
> > in?).  I also tried printing out the data between (*skb)->head to
> > (*skb)->data but I sometimes get funny data.  If I send a
> > stream of UDP
> > packets, the first one usually has a messed up MAC field
> > while all the other
> > ones are fine (sometimes it's totally random too!).  Am I
> > gaurenteed to have
> > a valid MAC address on the NF_IP_PRE_ROUTING hook? And if so,
> > where is it?
> > Sorry, if I got the wrong mailing list.  I wasn't sure which
> > one to ask on.
> > Regards, Max.
> >
> > P.s. I'm unable to subscribe to the list at the moment so
> > could you please
> > email me the solution. Thanks guys.
> >
> > _________________________________________________________________
> > MSN Photos is the easiest way to share and print your photos:
> > http://photos.msn.com/support/worldwide.aspx
> >
> >




_________________________________________________________________
MSN Photos is the easiest way to share and print your photos: 
http://photos.msn.com/support/worldwide.aspx
