From: Emmanuel Fleury <fleury@cs.auc.dk>
Subject: Re: Security flaw in Stateful filtering ??????
Date: Sat, 08 Jun 2002 03:42:20 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <3D0160FC.3050101@cs.auc.dk>
References: <E17G6im-0000FK-00@wagner.rustcorp.com.au> <3D006B9E.1040809@cs.auc.dk> <200206071105.42881.hno@marasystems.com> <3D007D73.9030609@cs.auc.dk> <20020607094319.GA595@morinfr.org> <3D00839F.6000103@cs.auc.dk> <20020607101713.GB595@morinfr.org> <3D009951.5090004@cs.auc.dk> <20020607133300.GD595@morinfr.org> <3D00CDB4.3060605@cs.auc.dk> <20020607183600.GD630@morinfr.org>
Reply-To: netfilter-devel@lists.samba.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Guillaume,

Guillaume Morin wrote:
> 
> The documentation is correct because it assumes you understand
> "connection" as a conntrack entry. 

Hum.

> I do agree that it should be  more explicit.

We met an agreement so.

>>The funny thing is that if you have a bad ruleset, you can easily be
>>DOSed by some external people which are just sending random ACK packets.
>>
>>Those ACKs will create entries in your connection table as ESTABLISHED
>>connections with a time-out of.... 5 days !!!!! 8-)
> 
> 
> Well no, since the concerned box will reply with a RST.

Try to imagine what if I try to address ACK to computer which are not
existing in your network.... see the picture now ???? :-)

Regards
-- 
Emmanuel

A dreamer is one who can only find his way by moonlight, and his
punishment is that he sees the dawn before the rest of the world.
   -- Oscar Wilde
