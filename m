From: "Colin Paton" <cozzarp@hotmail.com>
Subject: Re: PPTP connttrack problem - 'unexpecting' performed too early?
Date: Tue, 13 Apr 2004 13:31:51 +0000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <BAY13-F4JacRZ21n9x80005e0d9@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: philipc@snapgear.com
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

>Your log doesn't have any debug info from ip_nat_pptp.c or
>ip_nat_proto_gre.c.  Have you insmod'ed them?  If you haven't then
>that would explain why the keymap is wrong.

D'oh!

These modules weren't installed - I added them, as you suggested, and 
everything seems to work OK now!

I had originally built 'GRE protocol support' and 'PPTP protocol support' 
into the kernel - but if I build them as modules, then

modprobe ip_nat_pptp
modprobe ip_nat_proto_gre

...then everything works!

Thanks so much for your advice. I was busy going down a blind alleyway 
trying to figure out when the expects should be deleted - but didn't realise 
that they were incorrect. I'm still not quite sure why it worked when I kept 
them in, but it does appear to work properly now!

Thanks,

Colin

_________________________________________________________________
It's fast, it's easy and it's free. Get MSN Messenger today! 
http://www.msn.co.uk/messenger
