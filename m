From: Stephen Lee <mukansai@emailplus.org>
Subject: Re: Extremely slow network with e1000 & ip_conntrack
Date: Sat, 06 Dec 2003 07:20:09 +0900
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031206071129.D31D.MUKANSAI@emailplus.org>
References: <20031204213030.2B75.MUKANSAI@emailplus.org> <20031205122819.25ac14ab.davem@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: Stephen Lee <mukansai@emailplus.org>, scott.feldman@intel.com,
   laforge@netfilter.org, netfilter-devel@lists.netfilter.org,
   linux-kernel@vger.kernel.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "David S. Miller" <davem@redhat.com>
In-Reply-To: <20031205122819.25ac14ab.davem@redhat.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

"David S. Miller" <davem@redhat.com> wrote:
> 
> OK, I've found out what IP conntack does that creates the problems.
> [...]
> People can confirm this analysis by applying the patch below, enabling
> TSO with conntrack loaded, and see if the problem goes away.

I tested it with both e1000 & tg3, TSO on, and it is working fine for me
using ftp and scp.

Thanks,
Stephen
