From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2.6 NETFILTER] new netfilter module ipt_program.c
Date: Sat, 11 Sep 2004 14:51:24 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <4142F4CC.7080708@trash.net>
References: <20040911124106.GD24787@lkcl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	linux-kernel@vger.kernel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Luke Kenneth Casson Leighton <lkcl@lkcl.net>
In-Reply-To: <20040911124106.GD24787@lkcl.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Luke Kenneth Casson Leighton wrote:
> decided to put this into a separate module.  based on ipt_owner.c.
> does full program's pathname.  like ipt_owner, only suitable for
> outgoing connections.

I agree that it would be useful to match the full path, but
the patch is broken, as are the owner match's pid-, sid- and
command-matching options. You can't grab files->file_lock
outside of process context. Besides, we want to consolidate
functionality, not add new matches that do basically the same
as existing ones.

Regards
Patrick
