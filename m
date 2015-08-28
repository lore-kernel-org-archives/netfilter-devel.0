From: Gunjan Mehta <gunjanmehta08@gmail.com>
Subject: Identify Beacon Frame
Date: Fri, 28 Aug 2015 21:51:04 +0530
Message-ID: <CANBLUyKDCCZ1dFDQz4rVU94mW9RTxFNjWeB9w8Zxp9jx+jLRrQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7317965053772702396=="
To: kernelnewbies <kernelnewbies@kernelnewbies.org>,
	netfilter-devel@vger.kernel.org
Return-path: <kernelnewbies-bounces@kernelnewbies.org>
List-Unsubscribe: <http://lists.kernelnewbies.org/mailman/listinfo/kernelnewbies>,
	<mailto:kernelnewbies-request@kernelnewbies.org?subject=unsubscribe>
List-Archive: <http://lists.kernelnewbies.org/pipermail/kernelnewbies>
List-Post: <mailto:kernelnewbies@kernelnewbies.org>
List-Help: <mailto:kernelnewbies-request@kernelnewbies.org?subject=help>
List-Subscribe: <http://lists.kernelnewbies.org/mailman/listinfo/kernelnewbies>,
	<mailto:kernelnewbies-request@kernelnewbies.org?subject=subscribe>
Sender: kernelnewbies-bounces@kernelnewbies.org
Errors-To: kernelnewbies-bounces@kernelnewbies.org
List-Id: netfilter-devel.vger.kernel.org

--===============7317965053772702396==
Content-Type: multipart/alternative; boundary=bcaec51ddc6b64cc8a051e61784b

--bcaec51ddc6b64cc8a051e61784b
Content-Type: text/plain; charset=UTF-8

Hi All,

I am new to kernel development. I am writing a kernel module that captures
packet at the netfilter pre - routing hook.

I only want to capture the BEACON FRAME.

I have few queries:

1>When the beacon frame comes to receiving machine do the sk_buff gets
allocated?
2> How can i identify the beacon frame at the pre routing hook?
3> Beacon frame consist of a string for authentication of client with the
server, can i use sk_buff pointers to get access to that string, if sk_buff
is allocated?

Regards
Gunjan

--bcaec51ddc6b64cc8a051e61784b
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi All,<div><br></div><div>I am new to kernel development.=
 I am writing a kernel module that captures packet at the netfilter pre - r=
outing hook.</div><div><br></div><div>I only want to capture the BEACON FRA=
ME.</div><div><br></div><div>I have few queries:</div><div><br></div><div>1=
&gt;When the beacon frame comes to receiving machine do the sk_buff gets al=
located?</div><div>2&gt; How can i identify the beacon frame at the pre rou=
ting hook?</div><div>3&gt; Beacon frame consist of a string for authenticat=
ion of client with the server, can i use sk_buff pointers to get access to =
that string, if sk_buff is allocated?</div><div><br></div><div>Regards</div=
><div>Gunjan</div></div>

--bcaec51ddc6b64cc8a051e61784b--


--===============7317965053772702396==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Kernelnewbies mailing list
Kernelnewbies@kernelnewbies.org
http://lists.kernelnewbies.org/mailman/listinfo/kernelnewbies

--===============7317965053772702396==--
