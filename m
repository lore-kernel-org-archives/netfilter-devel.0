From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: netflow/sflow & Linux
Date: Tue, 23 Mar 2004 10:42:27 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1080034947.1620.13.camel@nienna.balabit>
References: <Pine.LNX.4.44.0403222123480.21687-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Henrik Nordstrom <hno@marasystems.com>,
	Netfilter Development <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Abraham van der Merwe <abz@frogfoot.net>
In-Reply-To: <Pine.LNX.4.44.0403222123480.21687-100000@filer.marasystems.com>
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

On Tue, 2004-03-23 at 00:00, Henrik Nordstrom wrote:
> > Yes, I know about that, but ntop is rather limited because it is just based
> > on libpcap.
> 
> I don't see what is wrong with that.

  I used to think there are serious scalability problems with the
libpcap approach. Requiring a context switch for each and every packet
simply won't work. However, yesterday I found on the ntop site that
there are serious improvements in this area, so now it _is_ possible to
process flows on gigabit interfaces using libpcap. Have a look at 
http://luca.ntop.org/Ring.pdf, I think it is well worth reading.

-- 
 Regards,
   Krisztian KOVACS
