From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [NEW TARGET] target for modifying conntrack timeout value
Date: Sun, 02 Jan 2005 14:15:19 +0100
Message-ID: <41D7F3E7.2070002@eurodev.net>
References: <EINSTEINUuEhjJ8uT6S00000759@einstein.systemmetrics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: 'Netfilter Development Mailinglist' <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Richard <richard@o-matrix.org>
In-Reply-To: <EINSTEINUuEhjJ8uT6S00000759@einstein.systemmetrics.com>
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

Richard wrote:

>The only change I made is 
>
>+#if 0
>+	ip_ct_refresh_acct(ct, 0, NULL, new_expires);
>+#endif
>+	ip_ct_refresh(ct, new_expires);
>
>This is because I got unresolved symbol ip_ct_refresh_acct when loading the
>kernel module. I am using kernel version 2.4.25.
>  
>
I forgot to tell you,  ip_ct_refresh was renamed to ip_ct_refresh_acct 
in 2.6.9. Ick, the API is kinda broken now :(. Since I work with lastest 
2.6 bk snapshot, I needed to use the new name. I think that it would be 
nice if you add a comment in that section of code to explain why you did 
that?

--
Pablo
