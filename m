From: "mase hare" <masehare@webmail.co.za>
Subject: Probing counters without calling IPtables -L
Date: Fri, 05 Mar 2004 16:51:01 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <web-250618034@mail01.infosat.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
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


Good day all NetFilter/IPtables developers!

I am a IPtables user, and I do like it very much.
Thats why I want to use IPtables with my development.
I want to develop my own C program to compilment
IPtables to do accounting on network traffic for me.

Now there is plenty of accounting programs available
on the web, but most uses scripts with the iptables -L -v
command to generate sumarry files.

I would like to build a stand-alone deamon to probe
only the specific rules' counters ( packets, bytes ),
thus no scripting, and no iptables -L -v.

I think this was possible with IPchaincs by looking in
a specific file in /proc/net/ip_*

---------------------------------
Now my question is:
Is there for IPtables also a file which one can cat
to read the counters from, in /proc/net/*?
And if not, what -in your opinions- would be the
best course for me to take
in getting these counters inside my C program
with their source and destination addresses.
---------------------------------

Thank You very much for the time and effort!
I do appriciate it truly.

Yours,

Mase Hare




__________________________________________________________________________
http://www.webmail.co.za/dialup Webmail ISP - Cool Connection, Cool Price
