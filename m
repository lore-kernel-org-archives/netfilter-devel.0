From: =?ISO-8859-1?Q?Bj=F6rn_Lindstr=F6m?= <bjorn.mailinglist@gmail.com>
Subject: checking rule specifications in a match
Date: Mon, 19 Jun 2006 11:08:36 +0200
Message-ID: <44966994.6020402@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
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

Hi.
I am writing an iptables match to match the IEC-60870-5-104 protocol.
I only want this match to be used on tcp packets and therefore I want=20
iptables to reject rules if does not specify tcp as the protocol (-p=20
tcp). I am currently doing this check in the checkentry function in the=20
kernel module. This works but the error message only say "iptables:=20
Unknown error 4294967295" if -p tcp is left out. Is it possible to do=20
this check any other way to get a more comprehensible error message?
Thanks.
Bj=F6rn Lindstr=F6m
