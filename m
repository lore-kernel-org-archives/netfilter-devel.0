From: "David S. Miller" <davem@redhat.com>
Subject: Re: Extremely slow network with e1000 & ip_conntrack
Date: Fri, 5 Dec 2003 14:56:24 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031205145624.5810bb71.davem@redhat.com>
References: <20031204213030.2B75.MUKANSAI@emailplus.org>
	<20031205122819.25ac14ab.davem@redhat.com>
	<20031206071129.D31D.MUKANSAI@emailplus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: mukansai@emailplus.org, scott.feldman@intel.com, laforge@netfilter.org,
        netfilter-devel@lists.netfilter.org, linux-kernel@vger.kernel.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Stephen Lee <mukansai@emailplus.org>
In-Reply-To: <20031206071129.D31D.MUKANSAI@emailplus.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sat, 06 Dec 2003 07:20:09 +0900
Stephen Lee <mukansai@emailplus.org> wrote:

> "David S. Miller" <davem@redhat.com> wrote:
> > 
> > OK, I've found out what IP conntack does that creates the problems.
> > [...]
> > People can confirm this analysis by applying the patch below, enabling
> > TSO with conntrack loaded, and see if the problem goes away.
> 
> I tested it with both e1000 & tg3, TSO on, and it is working fine for me
> using ftp and scp.

Great, I'll push the fix to Linus.

Thanks.
