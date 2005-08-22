From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/2] string match for iptables
Date: Mon, 22 Aug 2005 02:13:59 +0200
Message-ID: <430918C7.2090502@trash.net>
References: <43075BEA.1030701@trash.net>	<20050820.131403.37427784.davem@davemloft.net>	<430887CA.1080505@trash.net>
	<20050821.153436.09264518.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org,
	pablo@eurodev.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20050821.153436.09264518.davem@davemloft.net>
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

David S. Miller wrote:
> From: Patrick McHardy <kaber@trash.net>
> Date: Sun, 21 Aug 2005 15:55:22 +0200
> 
>>Where does it call kmalloc? net/compat.c uses compat_alloc_user_space
>>for the translated ruleset.
> 
> Sorry, that's the 2.4.x code, perhaps it should be converted
> to use either vmalloc() of compat_alloc_user_space().

I'll look into it after fixing the 2.6 compat code.
