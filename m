From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: NAT changing src-port
Date: Mon, 01 Mar 2004 17:51:05 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1078159865.675.82.camel@nienna.balabit>
References: <DAELKAPIKOFAFFKELNHOEEDBCAAA.listuser@epygi.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Nikolai Dahlem <listuser@epygi.de>
In-Reply-To: <DAELKAPIKOFAFFKELNHOEEDBCAAA.listuser@epygi.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


  Hi,

On Mon, 2004-03-01 at 13:16, Nikolai Dahlem wrote:
> request is not recognized. How can I get the port the new (changed)
> port from netfilter, to change the payload accordingly in my
> NAT-helper ?

  After setting up the NAT mappings with ip_nat_setup_info(), the new
source port is ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.u.all (ct is a
pointer to your conntrack structure).

-- 
 Regards,
   Krisztian KOVACS
