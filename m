From: DarKRaveR <DarKRaveR@habitat-b.de>
Subject: Re[2]: REJECT target
Date: Wed, 25 Jun 2003 16:13:43 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1051987037.20030625161343@habitat-b.de>
References: <Pine.LNX.4.33.0306250916010.7456-100000@blackhole.kfki.hu>
Reply-To: DarKRaveR <DarKRaveR@habitat-b.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <Pine.LNX.4.33.0306250916010.7456-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello Jozsef,

I understood that, the question is why ? I got a scenarion, where I
would need it in the PREROUTING chain of the nat table, instead of
just dropping the packets ... Is there any reason, why it is only
available in the filter table. I mean, it's for filtering okay, but
maybe I want to reject connections properly at other places (like nat
table, prerouting) instead of plain stupid
dropping them and waiting at the client software to time out.

Wednesday, June 25, 2003, 9:17:56 AM, you wrote:

JK> On Wed, 25 Jun 2003, DarKRaveR wrote:

>>   I know this is not really a developers question, but maybe the
>>   developers are the right people at hand, to explain this.
>>   From what I read, the REJECT target is only valid in
>>   INPUT/OUPUT/FORWARD. Is there any particular reason why ? I read in
>>   one of the tutorials, that you wouldn't need it at any other place,
>>   but I think this is not perfectly true.

JK> The REJECT target is for filtering. The filter table has got the
JK> INPUT/OUPUT/FORWARD chains, therfore the REJECT target can be used in
JK> those chains (and sub-chains, naturally).

JK> Best regards,
JK> Jozsef
JK> -
JK> E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
JK> PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
JK> Address : KFKI Research Institute for Particle and Nuclear Physics
JK>           H-1525 Budapest 114, POB. 49, Hungary




-- 
Best regards,
 DarKRaveR                            mailto:DarKRaveR@habitat-b.de
