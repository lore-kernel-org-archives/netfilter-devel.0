From: "David S. Miller" <davem@redhat.com>
Subject: Re: [netfilter-core] linux-2.6.0-testX ipchains oops in NAT
Date: Sun, 26 Oct 2003 23:58:44 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031026235844.2481be02.davem@redhat.com>
References: <3F97B874.CB12C184@fy.chalmers.se>
	<20031026063626.D0FCE2C04B@lists.samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: appro@fy.chalmers.se, laforge@netfilter.org, coreteam@netfilter.org,
        netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <20031026063626.D0FCE2C04B@lists.samba.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sun, 26 Oct 2003 17:19:38 +1100
Rusty Russell <rusty@rustcorp.com.au> wrote:

> We updated ip_nat_setup_info to set the initialized flag and call
> place_in_hashes, but *didn't* change the call in ip_fw_compat_masq.c
> which also calls place_in_hashes() itself (again!).  Result: corrupt
> list, and next thing which lands in the same hash bucket goes boom.
> 
> This should fix it.

Applied, thanks a lot Rusty.
