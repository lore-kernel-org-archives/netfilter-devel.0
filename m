From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: iptables throws unknown error - suspecting 32/64 compat issue
Date: Thu, 10 May 2007 15:24:45 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0705101521570.32349@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0705100812440.32349@yvahk01.tjqt.qr>
 <Pine.LNX.4.61.0705100832050.32349@yvahk01.tjqt.qr> <46431C0D.5080507@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@lists.netfilter.org>, sparclinux@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <46431C0D.5080507@trash.net>
Sender: sparclinux-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On May 10 2007 15:20, Patrick McHardy wrote:
>> 
>> And the following cmd oopsed it:
>> 
>> 	# iptables -A INPUT -p tcp --dport 22 -m conntrack --ctstate NEW
>> 	-j sshcheck;
>
>
>I believe this is a bug in the compat code, which *seems* to call (its
>a bit messy, I just had a quick look) the destroy function without
>having called checkentry previously when something goes wrong. Which
>commands did you run before this?

A lot ... as far as the filter table and sshcheck is concerned,

iptables -N sshcheck;
iptables -A sshcheck -m recent --name sshcheck --seconds 60 --update -j DROP;
iptables -A sshcheck -m hashlimit --hashlimit-name sshcheck \
        --hashlimit-mode srcip --hashlimit 4/min --hashlimit-burst 4 \
        -j RETURN;
iptables -A sshcheck -m recent --name sshcheck --set -j DROP;


	Jan
-- 
