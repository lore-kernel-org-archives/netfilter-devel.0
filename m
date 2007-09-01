From: =?UTF-8?B?67CV7KCV7JuQ?= <jwpark@whitecode.co.kr>
Subject: hashlimit match : how is that to use hop count as the hash info?
Date: Sat, 1 Sep 2007 15:16:45 +0900
Message-ID: <006601c7ec5f$ac158c10$0be810d2@JULIE>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

Hi,

Is it possible to use hop count (TTL) as the hash value?

I can=E2=80=99t find the way to defend against spoofing based DDoS =
attacks.

If the hop count and destination ip and destination port is used as hash =
value, it seems to be effective to defend against spoofing based DDoS =
attacks,=20

because the attacker do not spoof the hop count, and TTL value is of =
most packets will be different.

Sorry for my poor English!
