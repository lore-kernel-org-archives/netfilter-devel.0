From: "Wei Ming Long" <WEI_Ming_Long@dsi.a-star.edu.sg>
Subject: Auto IP configuration
Date: Tue, 10 Jun 2003 09:25:27 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <see5a40f.082@gwia>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <<netfilter-devel@lists.netfilter.org>>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi everyone,
I am thinking of setting up a wireless lan and hope to use my laptop as
wireless client with dynamic ip address, using dhcp & running netfilter on the
gateway. I use my laptop at office with a static ip address and configured
proxy server. My question is: Can netfilter do nat or packet filtering based
on mac address so that I do not have to change my network configurations each
time my network environment changes. 

Scenario 1 - With only my laptop

Internet ------------- Linux Gateway (ip address = 192.1681.1, Netfilter +
DHCP + Squid) -------------- My laptop A (ip address = 192.168.1.1)(dynamic)

Scenario 2 - With my laptop & a friend's laptop

Internet ------------- Linux Gateway +-------------- My laptop A (ip address
= 192.168.1.1) (dynamic)
                                  +
                                   |
                                   |
                                   |
                        Friend's laptop B (ip address = 172.16.1.1)
(static),

All help greatly appreciated. Thanks.

Best regards
Matthew
