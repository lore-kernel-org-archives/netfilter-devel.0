From: Pablo Neira <pablo@eurodev.net>
Subject: Re: iplimit issues
Date: Sat, 20 Nov 2004 20:17:22 +0100
Message-ID: <419F9842.4030908@eurodev.net>
References: <20041120162813.322af73a@elf>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Ury N. Stankevich" <urykhy@gmail.com>
In-Reply-To: <20041120162813.322af73a@elf>
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

Ury N. Stankevich wrote:

>i think we can use conntrack capabilities to store sessions and extent ipt_state.c to take in account number of sessions.
>  
>

right

>have anyone experiments with this approach ?
>  
>

We are still discussing this. Have a look at these threads:

http://lists.netfilter.org/pipermail/netfilter-devel/2004-October/017276.html
http://lists.netfilter.org/pipermail/netfilter-devel/2004-November/017314.html

--
Pablo
