From: "Martijn Lievaart" <m@rtij.nl>
Subject: RE: LAND check: 2.4.20
Date: Tue, 15 Mar 2005 17:42:56 +0100 (CET)
Message-ID: <19921.213.236.112.75.1110904976.squirrel@213.236.112.75>
References: <BB6D74C75CC76A419B6D6FA7C38317B26A263D@sinett-sbs.SiNett.LAN>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
In-Reply-To: <BB6D74C75CC76A419B6D6FA7C38317B26A263D@sinett-sbs.SiNett.LAN>
To: "Vishwas Manral" <Vishwas@sinett.com>
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

Vishwas Manral said:
> Hi Martin/ folks,
>
> Thanks. That was a lot of help. Can you point me to the code where the
> checks have been made?

They should be in your ruleset or you can use the Linux built in routing
checks. If you have an interface that connects to specific networks, there
is no reason to accept packets from another interface with a source
address in those specific networks. Your ruleset can and should check for
that. That should catch the LAND attack.

Obviously this does not work for every firewall, if you have some complex
multirouting scenario this may not be possible. But that is typically not
a firewall protecting Windows hosts, so in practice that should not be a
problem.

M4
