From: Robin Johnson <robbat2@orbis-terrarum.net>
Subject: Re: [NEW EXTENSION] Condition Match
Date: Tue, 29 Oct 2002 18:52:34 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3DBF4972.2020305@orbis-terrarum.net>
References: <3DBED94E.1030107@videotron.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Stephane Ouellette wrote:
> To enable the rules, issue:        echo 1 > /proc/net/ipt_condition/quake
> To disable the rules, issue:       echo 0> /proc/net/ipt_condition/quake
Just one suggestion with this, is /proc/net the right part of /proc for this?
/proc/net seems to be statistics reporting only, with /proc/net/sys/ipv{4,6} 
being where options are controlled.

> As of this writing, the condition match module supports only one 
> condition per rule.  I think I will add in a near future the possibility 
> to match on many conditions at the same time, using the syntax:     
> --condition file1,file2,file3. . .
This may be getting somewhat complex, but would it be possible to have binary 
ops on the conditions?
eg: --condition file1 --conditionand file2 etc. But this MIGHT be getting a 
little complex IMHO ;-).

Other than that, it looks like a wonderful idea to be able to turn off/on rules 
as needed.
