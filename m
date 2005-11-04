From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH 2/3] refcount leak of proto when ctnetlink dumping tuple
Date: Fri, 04 Nov 2005 18:41:25 +0100
Message-ID: <436B9D45.5070407@eurodev.net>
References: <200511041612.jA4GCVLl011680@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200511041612.jA4GCVLl011680@toshiba.co.jp>
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

Yasuyuki KOZAKAI wrote:
> Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
> 
> 
> ------------------------------------------------------------------------
> 
> [NETFILTER] refcount leak of proto when ctnetlink dumping tuple
> 
> Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

Thanks a lot for all the fixes. I've been busy fixing bugs in the
userspace part :(. BTW, I think that this patch fixes the bug reported
at dumping (Krzysztof).

As I told you during the workshop, I'll send a patch with the ctnetlink
port for nfnetlink asap.

-- 
Pablo
