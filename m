From: Patrick McHardy <kaber@trash.net>
Subject: Re: DNS rebinding
Date: Wed, 08 Aug 2007 16:14:16 +0200
Message-ID: <46B9CFB8.80003@trash.net>
References: <46B8999F.3060202@seclark.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Stephen.Clark@seclark.us
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46B8999F.3060202@seclark.us>
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

Stephen Clark wrote:
> Hello List,
> 
> There is an article about DNS rebinding at the following site:
> http://crypto.stanford.edu/dns/
> 
> 
> "Circumvention-Resistant Firewalls. Firewalls can prevent
> their own circumvention by forbidding external host
> names from resolving to internal IP addresses, preventing
> the attacker from naming the target server, either by filtering
> packets [6] or by modifying their DNS resolver."
> 
> Can netfilter be setup to keep dns responses from pointing to internal
> addresses by filtering the packets? If so how would one go about setting
> that up.

No, that would require a dns match. But IIRC someone posted something
like that based on nfnetlink_queue a couple of month ago ..
