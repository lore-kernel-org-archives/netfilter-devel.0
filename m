From: "Andrej Ricnik" <lemmetink@hotmail.com>
Subject: Re: accounting
Date: Sat, 15 Feb 2003 01:10:02 +0000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <F70HM4nPCkkds4rvdnC0000935b@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
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

>Hi,

>as for the logging of traffic, this is really easy. You could use an
>iptables rule, as DarKRaveR suggested, or just use snmp
>(interfaces.ifTable.ifEntry.ifInOctets*).

>But for the assurance of a given limit, you will need a lot more.
Well, I could insert the traffic details (source/dest, size, time)
in a postgres table and run a query from a cron-job every five
minutes which certainly would suffice my limits...


>Stop working, look here:
>https://rnvs.informatik.tu-chemnitz.de/Dynshaper/
>
>It is already up and running, doing everything you can dream of: shaping
>to a given limit, dynamic traffic adjustment based on long term traffic
>analysis, database backend, IP based class allocation, Web-Frontend,
>Database-Backend, ... and it's GPL!

>The only disadvantage: it seems there is only a German documentation.
Well, I downloaded it and read the docs... I don't think it
QUITE does what I want, because in this setup it will allow
the kids to hog the transfer as long as I'm not on, and only
pull the throttle once they used up all the transfer volume?
Maybe my German is a bit rusty, and I got it wrong, though ...



>Ciao!
>     Thomas


Cheers from windy Wellington,
Tink

-----BEGIN GEEK CODE BLOCK-----
Version: 3.12
GCM/IT/O d-(++)@ a C+(+++)@ UL++>+++ P+>+++ L++ E+@ W+@ N+ o? K? w---@(+) 
O+++(+)@ M-@ V? PS+ PE- Y+ PGP++ t- 5- X- R-(*) tv-@ b+ DI++ D-- G++ !e* 
h--- r++ z?
------END GEEK CODE BLOCK------


_________________________________________________________________
Add photos to your messages with MSN 8. Get 2 months FREE*. 
http://join.msn.com/?page=features/featuredemail
