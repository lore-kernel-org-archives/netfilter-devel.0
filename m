From: Amin Azez <azez@ufomechanic.net>
Subject: Re: [PATCH] chaostables
Date: Fri, 09 Mar 2007 09:35:37 +0000
Message-ID: <45F12A69.1060406@ufomechanic.net>
References: <Pine.LNX.4.61.0703080723280.2448@yvahk01.tjqt.qr> <20070308131412.08d9973e@lxorguk.ukuu.org.uk> <Line.LNX.4.64.0703080955060.8029@d.namei> <Pine.LNX.4.61.0703081652310.2448@yvahk01.tjqt.qr> <45F044A0.50001@trash.net> <Pine.LNX.4.61.0703082112300.521@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S2993085AbXCIJfv@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0703082112300.521@yvahk01.tjqt.qr>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

* Jan Engelhardt wrote, On 08/03/07 20:26:
> xt_portscan needs to keep track of what packets the machine has already 
> seen. So on the first SYN, the connection is marked with "1". (Then we 
> send our SYN-ACK... and the connection turns ESTABLISHED.) The next 
> packet that is received will be an ACK or an RST. But it must come 
> _exactly after_ the SYN, so just using --tcp-flags ACK will not work. A 
> state which can be remembered is required. For that, an automaton is 
> used, whose state is saved in the connection mark.

There would me more point in having this as a new match if it didn't
trample on the connection mark, but used it's own slot or flag-bit.

Sam
