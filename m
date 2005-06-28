From: Roberto Nibali <ratz@drugphish.ch>
Subject: Re: [PATCH] TCP window tracking patch backported from the 2.6 tree
Date: Tue, 28 Jun 2005 18:01:07 +0200
Message-ID: <42C17443.60909@drugphish.ch>
References: <Pine.LNX.4.58.0506281201590.12765@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.58.0506281201590.12765@blackhole.kfki.hu>
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

Hello Jozsef,

Thanks, looks like tomorrow is another netfilter day for me.

> The TCP window tracking patch backported from the 2.6 tree can now be
> found in the patch-o-matic-ng svn repository. The 2.4 version of the
> nf-log patch (which is required) has been updated as well.

Is the conntrack_error-api still needed and if so, where can I find it? 
I'm referring to:

https://svn.netfilter.org/netfilter/trunk/patch-o-matic-ng/patchlets/tcp-window-tracking/info

> Please report me any success/failure reports wether it's an improvement
> compared to the previous version in your environment or not.

Do you happen to have a changelog written down somewhere or shall I diff 
the two linux-2.4 patches?

Regards,
Roberto Nibali, ratz
-- 
echo '[q]sa[ln0=aln256%Pln256/snlbx]sb3135071790101768542287578439snlbxq'|dc
