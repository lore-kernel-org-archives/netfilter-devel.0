From: Emmanuel Fleury <fleury@cs.auc.dk>
Subject: Re: Security flaw in Stateful filtering ??????
Date: Sat, 08 Jun 2002 04:06:17 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <3D016699.9010301@cs.auc.dk>
References: <3D006B9E.1040809@cs.auc.dk> <200206071105.42881.hno@marasystems.com> <3D007D73.9030609@cs.auc.dk> <20020607094319.GA595@morinfr.org> <3D00839F.6000103@cs.auc.dk> <20020607101713.GB595@morinfr.org> <3D009951.5090004@cs.auc.dk> <20020607133300.GD595@morinfr.org> <3D00CDB4.3060605@cs.auc.dk> <20020607183600.GD630@morinfr.org> <20020607210026.B23410@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Patrick Schaaf <bof@bof.de>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Patrick Schaaf wrote:
>>>The funny thing is that if you have a bad ruleset, you can easily be
>>>DOSed by some external people which are just sending random ACK packets.
>>>
>>>Those ACKs will create entries in your connection table as ESTABLISHED
>>>connections with a time-out of.... 5 days !!!!! 8-)
>>
>>Well no, since the concerned box will reply with a RST.
> 
> Alternatively, if no answer comes back at all, the conntrack is in the
> (extra) state UNREPLIED. When the connection table becomes full, UNREPLIED
> connections are recycled preferentially.

Hey, this is not fair !!!!!

This behaviour is not described in ip_conntrack_proto_tcp.c.

Where is it coded ????





Anyway, I would suggest that this 'ACK is NEW' thing is not really
needed forever in your firewall. If this behaviour is active for a
certain amount of time after every reboot, it would be probably enough
to catch up all this pending connections and allow you to classify ACK
as INVALID most of the time....

This is just a suggestion...

Regards
-- 
Emmanuel

A dreamer is one who can only find his way by moonlight, and his
punishment is that he sees the dawn before the rest of the world.
   -- Oscar Wilde
