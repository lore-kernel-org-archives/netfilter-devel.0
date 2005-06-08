From: Patrick McHardy <kaber@trash.net>
Subject: NAT reservations
Date: Wed, 08 Jun 2005 20:45:22 +0200
Message-ID: <42A73CC2.4060608@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: hidden@balabit.hu
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

Hi Krisztian,

I'm currently working on the H.323 connection tracking helper and
need to NAT addresses that are later used in an expectation, but
I don't want to create the expectation immediately. This can't
be done currently because the final port number is unknown before
the expectation is created. Your NAT reservations patch looks like
it solves exactly this problem. Is there a version for current
kernels?

Regards
Patrick
