From: Andy Polyakov <appro@fy.chalmers.se>
Subject: Re: [netfilter-core] linux-2.6.0-testX ipchains oops in NAT
Date: Sun, 26 Oct 2003 14:31:32 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F9BCCB4.A7B190AD@fy.chalmers.se>
References: <20031026063626.D0FCE2C04B@lists.samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, coreteam@netfilter.org,
        Netfilter Development Mailinglist
 <netfilter-devel@lists.netfilter.org>,
        davem@redhat.com
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> We updated ip_nat_setup_info to set the initialized flag and call
> place_in_hashes, but *didn't* change the call in ip_fw_compat_masq.c
> which also calls place_in_hashes() itself (again!).  Result: corrupt
> list, and next thing which lands in the same hash bucket goes boom.
> 
> This should fix it.

I can confirm that the proposed patch does resolve the problem. Thank
you. A.
