From: Patrick McHardy <kaber@trash.net>
Subject: Re: [patch] POM-NG: runme message clarification and filename regex
 fixes (v3)
Date: Fri, 12 Jan 2007 17:20:40 +0100
Message-ID: <45A7B558.8040408@trash.net>
References: <200701111021.55817.alan.ezust@presinet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Alan Ezust <alan.ezust@presinet.com>
In-Reply-To: <200701111021.55817.alan.ezust@presinet.com>
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

Alan Ezust wrote:
> This patch (3rd attempt to submit), includes fixes to the messages, to clarify 
> where things went wrong (when they do go wrong), and also avoids picking up 
> backup files in the patchlets directory.

I fixed the whitespace damage and applied it, thanks.

> -		} elsif ($session->apply_patchlet($patchlet, !$opt_reverse, 1, "/tmp/pom-$$", $opt_verbose)) {
> -			print("applied\n");
> +		} 
> +		elsif ($session->apply_patchlet($patchlet, !$opt_reverse, 1, "/tmp/pom-$$", $opt_verbose)) {

Please make sure you don't mix reformating like this with
real changes.
