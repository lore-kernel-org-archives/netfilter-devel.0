From: Pablo Neira <pablo@eurodev.net>
Subject: Re: ULOG / netlink errors
Date: Sun, 28 Nov 2004 21:50:04 +0100
Message-ID: <41AA39FC.1000400@eurodev.net>
References: <20041128113728.GA17226@oasis.frogfoot.net>
	<41AA3723.9070708@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Abraham van der Merwe <abz@frogfoot.net>
In-Reply-To: <41AA3723.9070708@eurodev.net>
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

Pablo Neira wrote:

> this is ok, it's always a good idea to reduce the probability of an 
> overflow. But I think that you'll have problems anyway with traffers 
> rates bigger than ~20 Mbits/s.


well, this is true in ip_queue, don't know in ipt_ULOG, it depends on 
three/four parameters.

--
Pablo
