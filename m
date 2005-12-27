From: Grant Coady <grant_lkml@dodo.com.au>
Subject: Re: Linux 2.6.14.5
Date: Tue, 27 Dec 2005 16:45:54 +1100
Message-ID: <b2l1r1178g4tmhu1vhnimsksnpdpkiuigl@4ax.com>
References: <20051227005327.GA21786@kroah.com> <32b1r156pu7much2m94ajva2bmcs4mpcag@4ax.com> <43B0C788.3010803@trash.net>
Reply-To: gcoady@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: gcoady@gmail.com, Greg KH <gregkh@suse.de>,
	linux-kernel@vger.kernel.org, stable@kernel.org, torvalds@osdl.org,
	Netfilter Development Mailinglist
	<netfilter-devel@lists.netfilter.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932237AbVL0Fpi@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <43B0C788.3010803@trash.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, 27 Dec 2005 05:48:08 +0100, Patrick McHardy <kaber@trash.net> wrote:

>Grant Coady wrote:
>> netfilter is broken compared to 2.6.15-rc7 (first 2.6 kernel tested 
>> on this box) or 2.4.32 :(  Same ruleset as used for months.
>> 
>> Fails to recognise named chains with a useless error message:
>> 
>> "iptables: No chain/target/match by that name"
>
>Please give an example of a failing command.
+ iptables -A INPUT -p all --match state --state ESTABLISHED,RELATED -j ACCEPT
iptables: No chain/target/match by that name
+ iptables -A INPUT -p tcp --match state --state NEW --dport ftp --match limit --limit 3/min -j ACCEPT
iptables: No chain/target/match by that name
+ iptables -A INPUT -p tcp --match state --state NEW --dport ftp -j DROP
iptables: No chain/target/match by that name
+ iptables -A INPUT -p tcp --match state --state NEW --dport http --match limit --limit 12/min -j ACCEPT
iptables: No chain/target/match by that name
+ iptables -A INPUT -p tcp --match state --state NEW --dport http -j DROP
iptables: No chain/target/match by that name
  FORWARD + iptables -A FORWARD -p all --match state --state ESTABLISHED,RELATED -j ACCEPT
iptables: No chain/target/match by that name
+ iptables -A egress -p tcp --match state --state NEW --match multiport --dports ftp,http,pop3,nntp,pop3s -j ACCEPT
iptables: No chain/target/match by that name
+ iptables -A egress -p tcp --match state --state NEW --match multiport --dports https,rsync -j ACCEPT
iptables: No chain/target/match by that name
+ iptables -A egress -p all --match state --state NEW --match limit --limit 12/min -j ACCEPT
iptables: No chain/target/match by that name

See also: http://bugsplatter.mine.nu/bash/firewall/rc.firewall.gz
http://bugsplatter.mine.nu/test/boxen/deltree/iptables-vnL-2.6.14.4-dt
http://bugsplatter.mine.nu/test/boxen/deltree/iptables-vnL-2.6.14.5-dt

Grant.
