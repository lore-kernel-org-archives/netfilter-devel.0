From: "John A. Sullivan III" <john.sullivan@nexusmgmt.com>
Subject: RE: IPSEC and NAT
Date: Sat, 16 Oct 2004 10:59:34 -0400
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <1097938773.2833.87.camel@localhost>
References: <200410160653.i9G6rmMc025506@nmibwkms1.nexusmgmt.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Emiel Mols <emiel@fulgor-hosting.nl>
In-Reply-To: <200410160653.i9G6rmMc025506@nmibwkms1.nexusmgmt.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Sat, 2004-10-16 at 02:53, Emiel Mols wrote:
<snip>
> Indeed, the problem is that the packets get encrypted before reaching
> POSTROUTING. I've managed the patch you're referring to:
> 
> router linux # cat ../patch-o-matic-ng-20040621/ipsec-01-output-hooks/help
> [NETFILTER+IPSEC 1/4]
> 
> This patch adds new output hooks for IPsec. Packets traverse the hooks like
> this:
> 
> 1. -> (plain) FORWARD   -> POST_ROUTING -> (encrypted) LOCAL_OUT ->
> POST_ROUTING
> 2. -> (plain) LOCAL_OUT -> POST_ROUTING -> (encrypted) LOCAL_OUT ->
> POST_ROUTING
> 
> However, I can't get it patched on 2.6.8.1 (about 5 rejects) and 2.6.7 (1
> reject). This patch is just what I need, but further downgrading isn't an
> option. Has anyone succeeded with this patch in a recent 2.6 kernel?
I'd imagine you have but, just in case, have you applied any dependent
patches? For example, when I first applied the tcp window patch, I had
the same problem until I realized I had to apply all the pending patches
first.
> 
<snip>
-- 
John A. Sullivan III
Chief Technology Officer
Nexus Management
+1 207-985-7880
john.sullivan@nexusmgmt.com
