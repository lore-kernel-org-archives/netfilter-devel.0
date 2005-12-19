From: Pablo Neira Ayuso <pablo@eurodev.net>
Subject: Re: Conntrack + Connection owner
Date: Mon, 19 Dec 2005 18:14:00 +0100
Message-ID: <43A6EA58.9090201@eurodev.net>
References: <1b8130000512182054y7208121dtb6b20814540bbb3b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, netfilter@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Mikado 4VN <mikado4vn@gmail.com>
In-Reply-To: <1b8130000512182054y7208121dtb6b20814540bbb3b@mail.gmail.com>
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

Mikado 4VN wrote:
> Is it possible for conntrack to dump process ID that created the
> connection to userpsace (via libnetfilter_conntrack or etc...)? If
> there is one, please tell me how!
> Thank you!

There's something incomplete here: Do you mean to include the ID in the
event information or in the conntrack table dumping?

-- 
Pablo
