From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH] cleanup for random seed initialization ip_conntrack_hash_rnd
Date: Tue, 13 Apr 2004 10:19:31 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <407BA293.1090207@eurodev.net>
References: <407B1E91.5090206@eurodev.net> <20040412233025.GF1424@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>,
 netfilter-devel@lists.netfilter.org
In-Reply-To: <20040412233025.GF1424@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Harald,

Harald Welte wrote:

>On Tue, Apr 13, 2004 at 12:56:17AM +0200, Pablo Neira wrote:
>  
>
>>Hi Harald and list,
>>
>>Attached a clean up for the initialization of the random seed used in 
>>ip_conntrack. With this patch the random seed is initialized once when 
>>ip_conntrack is loaded instead of checking every time a conntrack is 
>>created whether it was already initialized or not. If I'm missing 
>>something, please let me know.
>>    
>>
>
>yes, you are missing that there might not be sufficient entropy yet at
>the time ip_conntrack is loaded (or, for that matter, consider a
>statically linked ip_conntrack).
>  
>
ok, that's makes me understand the reason why the initialization is done 
that way.

thanks,
Pablo
