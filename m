From: Jonas Berlin <jberlin@niksula.hut.fi>
Subject: Re: iptables compile error: NFC_IP_TOS undeclared
Date: Thu, 10 Feb 2005 17:18:09 +0200
Message-ID: <420B7B31.9000606@niksula.hut.fi>
References: <Pine.GSO.4.33.0502101706320.8272-100000@indigo>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, netfilter@lists.netfilter.org
To: Alexander Piavka <piavka@cs.bgu.ac.il>
In-Reply-To: <Pine.GSO.4.33.0502101706320.8272-100000@indigo>
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

Alexander Piavka wrote:

>gcc -O2 -Wall -Wunused -I/usr/src/linux-2.6.10-ct_sync-rc1/include
>-Iinclude/ -DIPTABLES_VERSION=\"1.3.0rc1\"  -fPIC -o
>extensions/libipt_dscp_sh.o -c extensions/libipt_dscp.c
>extensions/libipt_dscp.c: In function `init':
>extensions/libipt_dscp.c:29: error: `NFC_IP_TOS' undeclared (first use in
>this function)
>  
>
Could you give the output of the following three commands (run them from 
your iptables-1.3.0rc1 source directory):

  grep NFC_IP_TOS 
/usr/src/linux-2.6.10-ct_sync-rc1/include/linux/netfilter_ipv4.h

  grep netfilter_ipv4.h 
/usr/src/linux-2.6.10-ct_sync-rc1/include/linux/netfilter_ipv4/ip_tables.h

  grep ip_tables.h extensions/libipt_dscp.c

That could help solve the problem.

-- 
- xkr47
