From: Friedrich Lobenstock <fl@fl.priv.at>
Subject: Re: latest pom: base/connlimit breaks kernel 2.4.25 compile (+possible
 fix)
Date: Sun, 11 Apr 2004 02:04:46 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40788B9E.20009@fl.priv.at>
References: <Pine.LNX.4.44.0404110147400.6583-100000@filer.marasystems.com>
Reply-To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.44.0404110147400.6583-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Henrik Nordstrom wrote on 11.04.2004 01:58 MET:
> On Sat, 10 Apr 2004, Friedrich Lobenstock wrote:
> 
>>Can I really remove those lines completely?
> 
> Yes. The connlimit module already depends on conntrack by the calls to
> functions within conntrack.

Ok. So what do you want then? A corrected patch or a patch for the patch?

-- 
MfG / Regards
Friedrich Lobenstock
