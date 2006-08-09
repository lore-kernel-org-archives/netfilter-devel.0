From: Grant Coady <gcoady.lk@gmail.com>
Subject: Re: Filtering PPPoE
Date: Wed, 09 Aug 2006 12:34:18 +1000
Message-ID: <47iid2lhchbnrha9gi5js28b11vh8hp927@4ax.com>
References: <20060808103245.fen2mnkuyask004c@www.milivojevic.org>
Reply-To: Grant Coady <gcoady.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Aleksandar Milivojevic <alex@milivojevic.org>
In-Reply-To: <20060808103245.fen2mnkuyask004c@www.milivojevic.org>
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

On Tue, 08 Aug 2006 10:32:45 -0500, Aleksandar Milivojevic <alex@milivojevic.org> wrote:

>Hi,
>
>I'm attempting to place transparent firewall (on a Linux host  
>configured as bridge) between ADSL modem and some servers.  The  
>servers and ADSL modem "speak" PPPoE.
>
>Simplified diagram looks like this:
>
>   +------+     +--------+     +---------+
>   |ADSL  |     |bridge/ |     |server(s)|
>   |modem |-----|firewall|-----|         |
>   +------+     +--------+     +---------+
>
>The problem I have is that Netfilter does not see PPPoE packets on the  
>bridge.

Did you switch ADSL modem to bridge mode?

 network topology
 `````````````````
     ----------------            ------------                   LAN
   (                  )  Phone  |            |                Machines
  (  Big Bad Internet  )--------| ADSL Modem |
   (                  )   Line  |            |    100-Base-T
     ----------------            ------------       Switch     -----
                                       |               -------|     |
                             Public IP | X_WORLD      |        -----
                                       |              |        -----
                                 -------------        |     --|     |
                                |  ppp0/eth2  |      ---   |   -----
                                |             |     | \ |--    -----
           X_LOCAL2       <-----|eth1     eth0|-----|/ /|-----|     |
           192.168.2.0/24       |             |     | \ |--    -----
           100-Base-T           |  Firewall   |      ---   |   -----
           (spare localnet)      -------------        |     --|     |
                                                      |        -----
                                                      |        -----
                                                       -------|     |
                                               X_LOCAL         -----
                                               192.168.1.0/24

Though I don't port-forward to DMZ servers -- that's the spare localnet 
that I've not got around to using.

Grant.
