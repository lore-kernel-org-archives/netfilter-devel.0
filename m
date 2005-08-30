From: Samir Bellabes <sbellabes@mandriva.com>
Subject: Re: [PATCH] kill lockhelp for CLUSTERIP
Date: Tue, 30 Aug 2005 19:39:18 +0200
Message-ID: <m2oe7fqq7t.fsf@cerbere.dyndns.info>
References: <m2wtm3qsww.fsf@cerbere.dyndns.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Samir Bellabes <sbellabes@mandriva.com>
In-Reply-To: <m2wtm3qsww.fsf@cerbere.dyndns.info> (Samir Bellabes's message of
	"Tue, 30 Aug 2005 18:41:03 +0200")
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

Samir Bellabes <sbellabes@mandriva.com> writes:

> this fix the missing lockhelp.h in kernel > 2.6.13
sorry we don't need this, as CLUSTERIP has been merged upstream.

regards,
Samir Bellabes
