From: johan <johan.peeters111@gmail.com>
Subject: SNAT and contrack helpers
Date: Tue, 15 Sep 2015 22:33:19 +0200
Message-ID: <55F8808F.5050900@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:33630 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbbIOUdX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Sep 2015 16:33:23 -0400
Received: by wiclk2 with SMTP id lk2so45325278wic.0
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Sep 2015 13:33:22 -0700 (PDT)
Received: from [192.168.1.34] (200.49-242-81.adsl-dyn.isp.belgacom.be. [81.242.49.200])
        by smtp.googlemail.com with ESMTPSA id kb5sm22864435wjc.17.2015.09.15.13.33.21
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Tue, 15 Sep 2015 13:33:21 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

I just figured out that conntrack helpers don't obey the configured NAT 
rules when predicting the related streams. This starts to be an issue in 
MAP network deployments where each home user only gets a part of the 
available port range [1024-65534].

The MAP-T architecture is included for convenience (extract from 
draft-mdt-softwire-map-translation-01)

        User N

        Private IPv4

       |  Network

       |

    O--+---------------O

    |  | MAP-T CE      |

    | +-----+--------+ |

    | NAPT44|  MAP-T | `-.

    | +-----+      | |  -._   ,-------.                     .------.

    |       +--------+ |   ,-'         `-.                ,-'       `-.

    O------------------O  /              \   O---------O /   Public   \

                          /   IPv6 only   \  |  MAP-T  |/     IPv4     \

                         (    Network      --+  Border +-   Network     )

                          \ (MAP-T Domain)/  |  Relay  |\              /

    O------------------O  \              /   O---------O \             /

    |    MAP-T CE      |   ;".         ,-'                `-.       ,-'

    | +-----+--------+ | ,"   `----+--'                      ------'

    | NAPT44|  MAP-T | | ,"        |

    | +-----+        | |        IPv6 Server(s)

    |   |   +--------+ |         (v4 mapped

    O---.--------------O          address)

        |

          User M

        Private IPv4

          Network

In above architecture the (NAT44) NAPT [RFC2663] function on a MAP CE is 
extended with support for restricting the allowable TCP/UDP ports for a 
given IPv4 address. Restricting those TCP/UDP ports by using SNAT fails 
for related streams.

Lets take as an example a FTP client in ACTIVE mode which downloads a 
file form the WAN. On the NAT box placed between LAN and WAN next 
MASQUERADE rule is in place:

iptables -t nat -A zone_wan_postrouting -p tcp -j MASQUERADE --to-ports 
4000-4500

We will see that the NAT box uses ports in the range 4000-4500 for its 
control connection, however the data connection (predicted by the NAT 
box) will use the ports used by the FTP client instead of using a port 
out of the port range imposed by the MASQUERADE rule. The same problem 
is present for other helpers too as we have RTSP/SIP/IRC/...

I'm wondering how this issue can be fixed, all suggestions/ideas are 
welcome. Is there any specific reason why the NAT rules aren't checked 
for the predictions?

Kind regards

Johan Peeters
