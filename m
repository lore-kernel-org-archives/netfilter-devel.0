From: Friedrich Lobenstock <fl@fl.priv.at>
Subject: Re: limiting connection rate
Date: Thu, 22 Apr 2004 22:55:17 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40883135.20301@fl.priv.at>
References: <20040422201732.60347.qmail@web41906.mail.yahoo.com>
Reply-To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <20040422201732.60347.qmail@web41906.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello <realname missing>

Null Device wrote on 22.04.2004 22:17 MET:
> 
> i am using netfilter hooks only.
> is there a way i can limit the no of connections per
> second per ip using certail iptable or netfilter
> modules.
> i was unable to find any documentation on it.

Are you talking about client ip (where the connection comes from) or server 
ip (where the connection goes to)?

In general what about using
   -m state --state NEW
in combination with eg.
   -m limit --limit 3/s

-- 
MfG / Regards
Friedrich Lobenstock
