From: Pablo Neira <pablo@eurodev.net>
Subject: Re: conntrack match and locking
Date: Fri, 28 May 2004 14:39:53 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40B73319.6050503@eurodev.net>
References: <Pine.LNX.4.44.0405261804070.31237-100000@filer.marasystems.com> <Pine.LNX.4.58.0405271104570.27895@chris.camcom.co.uk> <40B72B46.9050908@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <40B72B46.9050908@eurodev.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi!

Pablo Neira wrote:

> Actually this is the process, when we read a conntrack from the 
> conntrack table we read_lock the table and increase its refcount (see 
> ip_conntrack_get). We don't lock a conntrack, we lock the table while 
> reading the conntrack/tuples pair.


sorry, see ip_conntrack_find_get! :-)

regards,
Pablo
