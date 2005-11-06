From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH] Fix type of ICMP_ID
Date: Sun, 06 Nov 2005 04:09:51 +0100
Message-ID: <436D73FF.7090301@eurodev.net>
References: <Pine.LNX.4.63.0511060358480.32033@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Krzysztof Oledzki <olenf@ans.pl>
In-Reply-To: <Pine.LNX.4.63.0511060358480.32033@bizon.gios.gov.pl>
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

Krzysztof Oledzki wrote:
> Hello,
> 
> [NETFILTER] Fix type of ICMP_ID
> 
> ICMP_ID is u_int16_t not u_int8_t. Handle this properly.
> 
> Signed-out-by: Krzysztof Piotr Oledzki <ole@ans.pl>

Good catch. Thanks.

-- 
Pablo
