From: Ozgur Akan <akan@aiqa.com>
Subject: Re: chain_cache
Date: Fri, 21 May 2004 13:35:09 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40ADDB5D.7070806@aiqa.com>
References: <Pine.LNX.4.44.0405211055180.21575-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-9; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developers List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0405211055180.21575-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Another problem is when we delete a rule the, the rule before the rule 
we deleted and the rule after the rule we deleted may be the same. This 
must be also checked. (I mean if we delete rule number 4, 3rd and 5th 
rules must be checked)  Because of this reason modificaiton of 
insert_rule is not enough.

I think writing a new function will be a better choice...

-- 
Ozgur Akan
