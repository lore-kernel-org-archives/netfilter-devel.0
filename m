From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: arptables ruleset not working when compiling on  fedora6,7,8/centos
 5/redhat 5
Date: Thu, 02 Jul 2009 18:58:39 +0200
Message-ID: <4A4CE73F.2070502@pandora.be>
References: <b2d58cb80906290712k33c1ebbvfc8e661cb34c502c@mail.gmail.com>  <56378e320906290721i63f969edm90aed19619decf71@mail.gmail.com>  <b2d58cb80906290751j7fb3976bx9d04fed852c8b451@mail.gmail.com>  <4A48D6AD.4010005@trash.net>  <b2d58cb80906290818t66616f70k2fe7596b906a8a4e@mail.gmail.com>  <4A48E14A.3060708@trash.net>  <b2d58cb80906290918q2da5af1ap87772755b3363032@mail.gmail.com> <b2d58cb80906300108q2ee5a060gf8013a88560d8820@mail.gmail.com> <4A4B32C4.8050800@trash.net> <alpine.LSU.2.00.0907011302390.3504@fbirervta.pbzchgretzou.qr> <4A4B461D.5050407@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Nishit Shah <nsshah.82@gmail.com>,
	Richard Horton <arimus.uk@googlemail.com>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, netfilter@vger.kernel.org,
	Jay Fenlason <fenlason@redhat.com>, mt@suse.de,
	jskala@redhat.com
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <4A4B461D.5050407@trash.net>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Patrick McHardy schreef:
> Jan Engelhardt wrote:
>> On Wednesday 2009-07-01 11:56, Patrick McHardy wrote:
>>> Nishit Shah wrote:
>>>> On Mon, Jun 29, 2009 at 9:48 PM, Nishit Shah<nsshah.82@gmail.com>=20
>>>> wrote:
>>>>> -/usr/include/linux/netfilter.h:#define NF_MAX_VERDICT NF_REPEAT
>>>>> +/usr/include/linux/netfilter.h:#define NF_MAX_VERDICT NF_STOP
>>>>>
>>>> I am adding the patch for the same.
>>> Please send this to Bart (CCed), who is maintaining arptables.
>>
>> There is also a rogue arptables_jf clone by some RedHat person =E2=80=
=94
>> no homepage, no point of download except distro .src.rpms =E2=80=94
>> and used by Fedora and openSUSE.
>>
>> Ccing the relevant persons responsible for that clone, which I am=20
>> also hereby accusing of failing to submit their stuff upstream=20
>> causing unnecessary extra hurdles for users.
>
> Thanks for pointing this out. Jay, please elaborate on why you've
> chosen to fork this instead of working with upstream.
>
>
I'm not sure when that code was created but I don't think it was a fork=
=2E=20
I have no idea why they didn't mention this to the netfilter team, it=20
would have spared me the trouble. I received a mail from someone at=20
RedHat about their tool on 20/10/2003 and I pointed out the sourceforge=
=20
project ebtables where it's maintained. I didn't know they were still=20
using their own version...

cheers,
Bart

