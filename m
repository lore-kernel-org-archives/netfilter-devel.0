From: Patrick McHardy <kaber@trash.net>
Subject: Re: connbytes: wrong depends on Kconfig
Date: Mon, 05 Sep 2005 00:31:04 +0200
Message-ID: <431B75A8.5050300@trash.net>
References: <1125808606.32363.1.camel@ceci.ws.ar> <431B1A24.4000304@trash.net>
	<1125872325.11932.8.camel@ceci.ws.ar>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Diego Woitasen <diegows@linux.org.ar>
In-Reply-To: <1125872325.11932.8.camel@ceci.ws.ar>
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

Diego Woitasen wrote:
> I used the yesterday svn snapshot of patch-o-matic and the error was
> there.
> 
> what tree are you talking about?

The current kernel tree. I've fixed it up in svn, but the connbytes
match there is already out of sync with the kernel.
