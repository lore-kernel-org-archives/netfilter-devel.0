From: Andras Kis-Szabo <kisza@securityaudit.hu>
Subject: Re: [RESEND][PATCH] Hop Limit match/target for IPv6
Date: Wed, 01 Jan 2003 16:16:57 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1041434217.930.14.camel@arwen.middleearth.hu>
References: <Pine.LNX.4.44.0212301950480.6450-200000@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7BIT
Cc: Netfilter Devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
In-reply-to: <Pine.LNX.4.44.0212301950480.6450-200000@dns.toxicfilms.tv>
To: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Dear Maciej,

It is a very useful m/t, many thanks for it!
We have got an experimental stub for it in the main module, but
currently unimplemented (in the main module :) ).
BCF the end of the year I have not got enough time to test your m/t (and
drop a mail to Harald). :( (But it looks like a working module.:))
Personally, I have got some problems related the hoplimit target. W/o
IPSec it can be very dangerous in IPv6 networks. (If the auto
configuration is enabled.) But the other hand with this target we can
hide the firewall and check the validity of the management messages.

Many thanks for it!

Regards,

	kisza

-- 
    Andras Kis-Szabo       Security Development, Design and Audit
-------------------------/        Zorp, NetFilter and IPv6
 kisza@SecurityAudit.hu /------------------------------------------->
