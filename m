From: Sebastien Tricaud <sebastien.tricaud@wengo.fr>
Subject: Knowing tables change
Date: Mon, 13 Mar 2006 12:47:48 +0100
Message-ID: <44155BE4.80001@wengo.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Hi folks,

I would like to know if there is a way to watch for tables alteration.

I am sure there is a better way than doing "iptables -t table -L" loop 
and compare with previously stored data.

When I look over Internet for possible answers, I can find something 
that would do the job. It seems libpkttnetlink is for this purpose. 
However no developments are latter than 2002. Is it a working stuff and 
nothing has to be improved anymore ?

At a lower level, I can see libnfnetlink is the low level library I can 
also use for it: there is the following quote -> "provides 
open/close/receive functions only to be used by other libraries 
libctnetlink/libpkttnetlink".


Do you know which lib should I use ?


Thanks,
Sebastien Tricaud.
