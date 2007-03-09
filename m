From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: [PATCH] chaostables
Date: Fri, 9 Mar 2007 11:19:26 +0100 (MET)
Message-ID: <Pine.LNX.4.61.0703091106280.8799@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0703080723280.2448@yvahk01.tjqt.qr>
 <20070308131412.08d9973e@lxorguk.ukuu.org.uk> <Line.LNX.4.64.0703080955060.8029@d.namei>
 <Pine.LNX.4.61.0703081652310.2448@yvahk01.tjqt.qr> <45F044A0.50001@trash.net>
 <Pine.LNX.4.61.0703082112300.521@yvahk01.tjqt.qr> <45F12A69.1060406@ufomechanic.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
	James Morris <jmorris@namei.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Netfilter Developer Mailing List
	<netfilter-devel@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S2993103AbXCIKXZ@vger.kernel.org>
In-Reply-To: <45F12A69.1060406@ufomechanic.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hello,

On Mar 9 2007 09:35, Amin Azez wrote:
>* Jan Engelhardt wrote, On 08/03/07 20:26:
>> xt_portscan needs to keep track of what packets the machine has already 
>> seen. So on the first SYN, the connection is marked with "1". (Then we 
>> send our SYN-ACK... and the connection turns ESTABLISHED.) The next 
>> packet that is received will be an ACK or an RST. But it must come 
>> _exactly after_ the SYN, so just using --tcp-flags ACK will not work. A 
>> state which can be remembered is required. For that, an automaton is 
>> used, whose state is saved in the connection mark.
>
>There would me more point in having this as a new match if it didn't
>trample on the connection mark, but used it's own slot or flag-bit.

Adding a member to the ip_conntrack/nf_conntrack and sk_buff struct would
increase the struct sizes, and that would penalize users who do not intend
to use xt_portscan.

I do not see why the packet/connection marks should not be used to record
additional information. After all, that is what users use marks for.
xt_portscan can be precisely configured how to set its marks (mask is
supported), so that it only takes away 4 bits of the 32-bit connection
mark and 1 bit of the 32-bit packet mark.

Almost never I required connection marking myself except for this
portscanning automaton and perhaps a little MARK here and there for
finely-tuned SNAT. Again, things might look different on your side(s).
QoS, while primarily using CLASSIFY, is one point where MARK can be used.
I would assume that those who use xt_portscan should be fine with the
remaining 24 bits.


Thank you,

Jan
-- 
