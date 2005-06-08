From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: NAT reservations
Date: Wed, 08 Jun 2005 20:55:44 +0200
Message-ID: <1118256945.13271.6.camel@krak.odu>
References: <42A73CC2.4060608@trash.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <42A73CC2.4060608@trash.net>
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


  Hi,

On Wed, 2005-06-08 at 20:45 +0200, Patrick McHardy wrote:
> I'm currently working on the H.323 connection tracking helper and
> need to NAT addresses that are later used in an expectation, but
> I don't want to create the expectation immediately. This can't
> be done currently because the final port number is unknown before
> the expectation is created. Your NAT reservations patch looks like
> it solves exactly this problem. Is there a version for current
> kernels?

  Unfortunately I did not have time to port the patch for new NAT code
of 2.6.11, but a 2.6.10 version can be found in the latest tproxy
release tarball:

  http://www.balabit.com/downloads/tproxy/linux-2.6/

  That's the most up-to-date version available.

  Plus, I think the whole patch would require a thorough refresh, I
don't really like the idea of that extra hash table, etc. (And even that
hash table is poorly implemented, obsolete hash function, etc.)

--
 Regards, 
  Krisztian Kovacs
