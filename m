From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables throws unknown error - suspecting 32/64 compat issue
Date: Thu, 10 May 2007 15:20:13 +0200
Message-ID: <46431C0D.5080507@trash.net>
References: <Pine.LNX.4.61.0705100812440.32349@yvahk01.tjqt.qr> <Pine.LNX.4.61.0705100832050.32349@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List
	<netfilter-devel@lists.netfilter.org>, sparclinux@vger.kernel.org
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0705100832050.32349@yvahk01.tjqt.qr>
Sender: sparclinux-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jan Engelhardt wrote:
> On May 10 2007 08:27, Jan Engelhardt wrote:
> 
>>As mentioned in the topic, I suspect it is due to 32-bit iptables not 
>>coping correctly with the 64-bit kernel (sometimes, patches to fix these 
>>are posted, so I thought it could be related). OS is Aurora Linux 2.98, 
>>with their latest(?) kernel 2.6.20-1.2986.al3.3smp.
> 
> 
> And the following cmd oopsed it:
> 
> 	# iptables -A INPUT -p tcp --dport 22 -m conntrack --ctstate NEW
> 	-j sshcheck;


I believe this is a bug in the compat code, which *seems* to call (its
a bit messy, I just had a quick look) the destroy function without
having called checkentry previously when something goes wrong. Which
commands did you run before this?

