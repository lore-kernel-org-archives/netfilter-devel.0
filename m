From: Pablo Neira <pablo@eurodev.net>
Subject: Re: Probing counters without calling IPtables -L
Date: Fri, 05 Mar 2004 20:01:56 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4048CEA4.1050604@eurodev.net>
References: <web-250618034@mail01.infosat.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: mase hare <masehare@webmail.co.za>,
 netfilter-devel@lists.netfilter.org
In-Reply-To: <web-250618034@mail01.infosat.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi mase,

mase hare wrote:

>Good day all NetFilter/IPtables developers!
>
>I am a IPtables user, and I do like it very much.
>Thats why I want to use IPtables with my development.
>I want to develop my own C program to compilment
>IPtables to do accounting on network traffic for me.
>
>Now there is plenty of accounting programs available
>on the web, but most uses scripts with the iptables -L -v
>command to generate sumarry files.
>
>I would like to build a stand-alone deamon to probe
>only the specific rules' counters ( packets, bytes ),
>thus no scripting, and no iptables -L -v.
>
>I think this was possible with IPchaincs by looking in
>a specific file in /proc/net/ip_*
>
>---------------------------------
>Now my question is:
>Is there for IPtables also a file which one can cat
>to read the counters from, in /proc/net/*?
>And if not, what -in your opinions- would be the
>best course for me to take
>in getting these counters inside my C program
>with their source and destination addresses.
>---------------------------------
>  
>
Anyway, if you are thinking about reading from /proc/net/* in short 
period of time, you must take into account that this will decrease 
considerably the performance. Harald pointed out a similar issue for 
iptstate.

regards,
Pablo
