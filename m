From: Friedrich Lobenstock <fl@fl.priv.at>
Subject: Re: Memory Loading
Date: Mon, 19 Apr 2004 22:27:28 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40843630.6060908@fl.priv.at>
References: <40842F4C.6050608@rocksteady.com>
Reply-To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <40842F4C.6050608@rocksteady.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Patrick Turley wrote on 19.04.2004 21:58 MET:
> Our system has potentially a few thousand firewall rules. I need to find 
> out the amount of memory these that firewall rules consume. If you have 
> this information at hand, or can point me to a useful web site, that 
> would be great. Failing that, a pointer to specific source files would 
> also be marvelous.
> 

Would be interesting to know what you find out about this.

# iptables -L -n | wc -l
    6323                       (minus some few lines of text output)

That's 99.8% "accounting-only" rules with 0.2% filtering rules.

BTW I have set hashsize = ip_conntrack_max = 1785961. Therefore max. 510 MB 
will be allocate to conntrack. That much max. memory for conntrach will 
probably never be needed at all, but the memory is there, so why not ;-). I 
think this had more influence on the memory usage than all the rules 
together. No exact numbers to compare with, sorry.

How many rules would you want to install?

-- 
MfG / Regards
Friedrich Lobenstock
