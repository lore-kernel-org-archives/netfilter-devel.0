From: Friedrich Lobenstock <fl@fl.priv.at>
Subject: Re: extra/pptp-conntrack-nat.patch
Date: Fri, 11 Apr 2003 18:40:34 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E96F002.5000700@fl.priv.at>
References: <Pine.LNX.4.44.0304110659110.12367-100000@localhost.localdomain>
Reply-To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.44.0304110659110.12367-100000@localhost.localdomain>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Ilguiz Latypov wrote:
> 
> Are you connecting to the Windows server from the Linux machine where PPTP
> connection tracking modules are loaded?

No. It looks like this:

Windows-PC ---------> Linux Firewall --------------> Windows Server
  PPTP-Client           connection tracking             PPTP-Server
  private IP        private          official
                      IP                IP

> If this is true, you would be affected by the modules' rewriting of call
> IDs in one direction only when you were running the unmodified version.

I don't see a connection to a bad checksum here?

> 
> To be able to connect from such Linux machine to another PPTP server, you
> need to apply the pending local NAT patch from the netfilter patch-o-matic
> and enable the CONFIG_NF_NAT_LOCAL option in the kernel.
> 
> There would be nothing Windows specific in this case.

I don't think that I need the local nat stuff, do I?

PS: Can I tell the runme script of patch-o-matic to list all applied
patches? As far as I know it only shows the applied patches when you
tell it to apply some patches, but I can not export this list to a file.

-- 
MfG / Regards
Friedrich Lobenstock
____________________________________________________________________
Friedrich Lobenstock                       Linux Services Lobenstock
URL: http://www.lsl.at/                         Email: fl@fl.priv.at
____________________________________________________________________
