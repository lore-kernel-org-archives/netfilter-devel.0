From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables throws unknown error - suspecting 32/64 compat issue
Date: Thu, 10 May 2007 16:02:18 +0200
Message-ID: <464325EA.8040303@trash.net>
References: <Pine.LNX.4.61.0705100812440.32349@yvahk01.tjqt.qr>	<Pine.LNX.4.61.0705100832050.32349@yvahk01.tjqt.qr>	<46431C0D.5080507@trash.net> <Pine.LNX.4.61.0705101521570.32349@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: sparclinux@vger.kernel.org,
	Netfilter Developer Mailing List
	<netfilter-devel@lists.netfilter.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0705101521570.32349@yvahk01.tjqt.qr>
Sender: sparclinux-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jan Engelhardt wrote:
> On May 10 2007 15:20, Patrick McHardy wrote:
> 
>>>And the following cmd oopsed it:
>>>
>>>	# iptables -A INPUT -p tcp --dport 22 -m conntrack --ctstate NEW
>>>	-j sshcheck;
>>
>>
>>I believe this is a bug in the compat code, which *seems* to call (its
>>a bit messy, I just had a quick look) the destroy function without
>>having called checkentry previously when something goes wrong. Which
>>commands did you run before this?
> 
> 
> A lot ... as far as the filter table and sshcheck is concerned,
> 
> iptables -N sshcheck;
> iptables -A sshcheck -m recent --name sshcheck --seconds 60 --update -j DROP;
> iptables -A sshcheck -m hashlimit --hashlimit-name sshcheck \
>         --hashlimit-mode srcip --hashlimit 4/min --hashlimit-burst 4 \
>         -j RETURN;
> iptables -A sshcheck -m recent --name sshcheck --set -j DROP;


Did you get an "invalid size" message in the ringbuffer before the oops?
