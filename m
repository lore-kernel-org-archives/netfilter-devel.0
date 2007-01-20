From: Patrick McHardy <kaber@trash.net>
Subject: Re: PPTP Problem with 2.6.20-rc1 >=
Date: Sat, 20 Jan 2007 16:45:37 +0100
Message-ID: <45B23921.9020700@trash.net>
References: <087801c73c89$cb5e00b0$0301a8c0@hercules.decimalint.pt><45B208B0.8050707@trash.net>	<08ac01c73c9d$fa6ce100$0301a8c0@hercules.decimalint.pt>
	<091101c73ca3$01df0f80$0301a8c0@hercules.decimalint.pt>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jorge Bastos <mysql.jorge@decimal.pt>
In-Reply-To: <091101c73ca3$01df0f80$0301a8c0@hercules.decimalint.pt>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Jorge Bastos wrote:
> Ok, i've applied the patch, and recompiled the kernel module but, still
> nothing:

Thanks. I trust you properly installed the modules and reloaded the PPTP
helper and GRE conntrack modules?
