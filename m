Received: from vybihal.cz (vybihal.cz [37.205.8.242])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 209C2134A3;
	Sun,  7 Jan 2024 12:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vybihal.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vybihal.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vybihal.cz header.i=@vybihal.cz header.b="vKBZmTcd"
Message-ID: <d069ccef6d5913a6d24291fea134fa198a60e544.camel@vybihal.cz>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vybihal.cz; s=mail;
	t=1704631072; bh=FuRGMSLBiiUWYXp1mPKtKqHJdC0X/1hPpGDHsJoaSwo=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=vKBZmTcd0SQ/pTyIyMlmAm3YonHbPfqYbJng3O71+yX8oP9OsHHdO7l28JBeu9rBa
	 7K0QWCFt1UVbbCcX3+e9dPqz1USKi6uYkpXWeDxIBJJvCuOtUnfXJxly/p+nLG2Bw1
	 ZOZCc1yU8yOvBkRdtsw9c/IG1eFk2I0qNVqgteh8=
Subject: Re: GUI Frontend for iptables and nftables Linux firewalls
From: Josef =?ISO-8859-1?Q?Vyb=EDhal?= <josef@vybihal.cz>
To: Turritopsis Dohrnii Teo En Ming <teo.en.ming@protonmail.com>, Phil
 Sutter <phil@nwl.cc>
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>, 
	"ceo@teo-en-ming-corp.com"
	 <ceo@teo-en-ming-corp.com>, "netfilter@vger.kernel.org"
	 <netfilter@vger.kernel.org>
Date: Sun, 07 Jan 2024 13:37:49 +0100
In-Reply-To: <Xn0aN3rxNQeDGkg3zRrA6dSOm2vtar0_qVHQ0qJ_T4Cg4r0ZNJTE_sM542aOVZBG3n5D1Y0QH8R0tYb_klArPSOybckWd1HnttmaUOOqy1I=@protonmail.com>
References: 
	<F2UgPsJY77kOox0aLlaT8ezVQQdgsDcsP95OPo5wyKzn230KLtlp1R_NHDRcM2FzpUByrp72jC2s1qu-7aV6kNmig0Rxn1Bly-ci51RE7t4=@protonmail.com>
	 <ZZNwZEZtspTDLglp@orbyte.nwl.cc>
	 <Xn0aN3rxNQeDGkg3zRrA6dSOm2vtar0_qVHQ0qJ_T4Cg4r0ZNJTE_sM542aOVZBG3n5D1Y0QH8R0tYb_klArPSOybckWd1HnttmaUOOqy1I=@protonmail.com>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-GbovYzzkmtIQU+FqJwCO"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0


--=-GbovYzzkmtIQU+FqJwCO
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Not sure how relevant is this for you, but opensnitch [1] is in my
opinion very interesting project. It uses ebpf, so it has much more
capabilites.

Cheers,
Josef

[1] https://github.com/evilsocket/opensnitch

On Fri, 2024-01-05 at 06:53 +0000, Turritopsis Dohrnii Teo En Ming
wrote:
> On Tuesday, January 2nd, 2024 at 10:09 AM, Phil Sutter <phil@nwl.cc>
> wrote:
>=20
>=20
> > Hi,
> >=20
> > On Mon, Dec 25, 2023 at 03:26:13PM +0000, Turritopsis Dohrnii Teo En
> > Ming wrote:
> >=20
> > > Subject: GUI Frontend for iptables and nftables Linux firewalls
> > >=20
> > > Good day from Singapore,
> > >=20
> > > Besides Webmin, are there any other good GUI frontends for
> > > iptables and nftables?
> >=20
> >=20
> > This is a question better asked on netfilter@vger.kernel.org.
> >=20
> > > The GUI frontend needs to allow complex firewall configurations. I
> > > think Webmin only allows simple firewall configurations.
> >=20
> >=20
> > I was once told fwbuilder[1] is a nice tool for that purpose but I
> > never
> > really used it and it seems dead ("Last Update: 2013-07-03", if
> > sf.net
> > is to be trusted).
> >=20
> > Cheers, Phil
> >=20
> > [1] https://fwbuilder.sourceforge.net/
>=20
> Dear Phil,
>=20
> I think I have given up looking for the best GUI frontend for iptables
> and nftables Linux firewalls. All of the software projects are either
> immature or abandoned. I think I will stick to firewall distros
> instead.
>=20
> Thank you.
>=20
> Regards,
>=20
> Mr. Turritopsis Dohrnii Teo En Ming
> Targeted Individual in Singapore
>=20

--=-GbovYzzkmtIQU+FqJwCO
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCCEy0w
ggXaMIIDwqADAgECAhBxSiUXWFjM7vxDKA6Ct/TYMA0GCSqGSIb3DQEBCwUAMIGBMQswCQYDVQQG
EwJJVDEQMA4GA1UECAwHQmVyZ2FtbzEZMBcGA1UEBwwQUG9udGUgU2FuIFBpZXRybzEXMBUGA1UE
CgwOQWN0YWxpcyBTLnAuQS4xLDAqBgNVBAMMI0FjdGFsaXMgQ2xpZW50IEF1dGhlbnRpY2F0aW9u
IENBIEczMB4XDTIzMDMwMTEwNDAxOFoXDTI0MDMwMTEwNDAxN1owGzEZMBcGA1UEAwwQam9zZWZA
dnliaWhhbC5jejCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBALPJS9Etlj2HdBVuzADe
5SdCnCmYxbU019oYAfdKzPKwAhMlu7tn6uoJikr+YpHckei53cjer+4xIYEJ60TNOjcqWkiGEwlZ
FUt4Obr+qN8Uk51qoUiMPiXQ8Jej1g3z9QO5EOBc/TBliqlBHq5gQn1z6KNJQiSSt+r9Dn4N3I72
gPiL2ATg243RMlK2vHc3fqd01IH+i7vEFbu3Bn911OyBRGIFQwx0egOVlGWJ3l5u+2Qfd0tquuQ3
mouJVVpasCj5pA7pR34MLs/VRd9RHvOyP3TbSWenR/92f+Xy3T9FvoorQ/9or83LGWzWsfjEVLz8
SoJoBmlBtJBqX5K+ORkCAwEAAaOCAbEwggGtMAwGA1UdEwEB/wQCMAAwHwYDVR0jBBgwFoAUvpep
qoS/gL8QU30JMvnhLjIbz3cwfgYIKwYBBQUHAQEEcjBwMDsGCCsGAQUFBzAChi9odHRwOi8vY2Fj
ZXJ0LmFjdGFsaXMuaXQvY2VydHMvYWN0YWxpcy1hdXRjbGlnMzAxBggrBgEFBQcwAYYlaHR0cDov
L29jc3AwOS5hY3RhbGlzLml0L1ZBL0FVVEhDTC1HMzAbBgNVHREEFDASgRBqb3NlZkB2eWJpaGFs
LmN6MEcGA1UdIARAMD4wPAYGK4EfARgBMDIwMAYIKwYBBQUHAgEWJGh0dHBzOi8vd3d3LmFjdGFs
aXMuaXQvYXJlYS1kb3dubG9hZDAdBgNVHSUEFjAUBggrBgEFBQcDAgYIKwYBBQUHAwQwSAYDVR0f
BEEwPzA9oDugOYY3aHR0cDovL2NybDA5LmFjdGFsaXMuaXQvUmVwb3NpdG9yeS9BVVRIQ0wtRzMv
Z2V0TGFzdENSTDAdBgNVHQ4EFgQUDH+/qXnAbkmhS4Yr/v7AIMHPaZIwDgYDVR0PAQH/BAQDAgWg
MA0GCSqGSIb3DQEBCwUAA4ICAQCHA1ifxIT1PF8KFxccWEjvyBbsSPzTWtR2sZ+jQt3MUOjdeuIN
EmEbYK8m/0/kyxGIFIG8GrVOI/Yr/za7FTDgQQBwweWx8ShdHCGXaWCTuL0jsaHjfm+9l0jJBqnP
G0bb0Vg0aVgQYThK/TiUgzZAS+PBcfWQz57dhDOsvf80ZWugwivOmQ85bSXFnNmAzjDvBtJ0WhHt
rLqAX8EUUyMDJ8iPycgeL0+lgOC1B3lcLRfVEskUVux71le8RpB326fT6C4PE15aUeIJvlLAKf/G
qePLX00MdMraVKI+azkb0TSsxTZMRsbffuSDZ3k6VxT3jve7qgme1Xsl3lds5l09syZZN8eon2xT
2S8JVobygoKDNndysZKUSF6a3U3W5Qpf31sR+s/l/WxBez4wEWcu8XfLLwpchi2jKffpGQrFvTCl
5BwI7P53NaHrX+o3IIMayIaZn5efM/Tgi8Ku1Gnx+eieD50H8ZFTScPadAGTuvhPDqxbkoAjFr+v
W8QmifSrYeay7xPUxUjBgZ6k0XAhO9kBxiBxPXYtTgqF/vnMDp3ww5TW5auuyqwWwOatMLJsJiFn
nc0+fS6HVjuNDkrtbwqMqUOaiam6umPyIu1Zy4z/OKLMmcuvYJ8Zxb++g4phxzL6X/7E7R+uOzC1
1FuUyAxq/Tk+dzsrJYPHB6ZC6jCCBdowggPCoAMCAQICEHFKJRdYWMzu/EMoDoK39NgwDQYJKoZI
hvcNAQELBQAwgYExCzAJBgNVBAYTAklUMRAwDgYDVQQIDAdCZXJnYW1vMRkwFwYDVQQHDBBQb250
ZSBTYW4gUGlldHJvMRcwFQYDVQQKDA5BY3RhbGlzIFMucC5BLjEsMCoGA1UEAwwjQWN0YWxpcyBD
bGllbnQgQXV0aGVudGljYXRpb24gQ0EgRzMwHhcNMjMwMzAxMTA0MDE4WhcNMjQwMzAxMTA0MDE3
WjAbMRkwFwYDVQQDDBBqb3NlZkB2eWJpaGFsLmN6MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIB
CgKCAQEAs8lL0S2WPYd0FW7MAN7lJ0KcKZjFtTTX2hgB90rM8rACEyW7u2fq6gmKSv5ikdyR6Lnd
yN6v7jEhgQnrRM06NypaSIYTCVkVS3g5uv6o3xSTnWqhSIw+JdDwl6PWDfP1A7kQ4Fz9MGWKqUEe
rmBCfXPoo0lCJJK36v0Ofg3cjvaA+IvYBODbjdEyUra8dzd+p3TUgf6Lu8QVu7cGf3XU7IFEYgVD
DHR6A5WUZYneXm77ZB93S2q65Deai4lVWlqwKPmkDulHfgwuz9VF31Ee87I/dNtJZ6dH/3Z/5fLd
P0W+iitD/2ivzcsZbNax+MRUvPxKgmgGaUG0kGpfkr45GQIDAQABo4IBsTCCAa0wDAYDVR0TAQH/
BAIwADAfBgNVHSMEGDAWgBS+l6mqhL+AvxBTfQky+eEuMhvPdzB+BggrBgEFBQcBAQRyMHAwOwYI
KwYBBQUHMAKGL2h0dHA6Ly9jYWNlcnQuYWN0YWxpcy5pdC9jZXJ0cy9hY3RhbGlzLWF1dGNsaWcz
MDEGCCsGAQUFBzABhiVodHRwOi8vb2NzcDA5LmFjdGFsaXMuaXQvVkEvQVVUSENMLUczMBsGA1Ud
EQQUMBKBEGpvc2VmQHZ5YmloYWwuY3owRwYDVR0gBEAwPjA8BgYrgR8BGAEwMjAwBggrBgEFBQcC
ARYkaHR0cHM6Ly93d3cuYWN0YWxpcy5pdC9hcmVhLWRvd25sb2FkMB0GA1UdJQQWMBQGCCsGAQUF
BwMCBggrBgEFBQcDBDBIBgNVHR8EQTA/MD2gO6A5hjdodHRwOi8vY3JsMDkuYWN0YWxpcy5pdC9S
ZXBvc2l0b3J5L0FVVEhDTC1HMy9nZXRMYXN0Q1JMMB0GA1UdDgQWBBQMf7+pecBuSaFLhiv+/sAg
wc9pkjAOBgNVHQ8BAf8EBAMCBaAwDQYJKoZIhvcNAQELBQADggIBAIcDWJ/EhPU8XwoXFxxYSO/I
FuxI/NNa1Haxn6NC3cxQ6N164g0SYRtgryb/T+TLEYgUgbwatU4j9iv/NrsVMOBBAHDB5bHxKF0c
IZdpYJO4vSOxoeN+b72XSMkGqc8bRtvRWDRpWBBhOEr9OJSDNkBL48Fx9ZDPnt2EM6y9/zRla6DC
K86ZDzltJcWc2YDOMO8G0nRaEe2suoBfwRRTIwMnyI/JyB4vT6WA4LUHeVwtF9USyRRW7HvWV7xG
kHfbp9PoLg8TXlpR4gm+UsAp/8ap48tfTQx0ytpUoj5rORvRNKzFNkxGxt9+5INneTpXFPeO97uq
CZ7VeyXeV2zmXT2zJlk3x6ifbFPZLwlWhvKCgoM2d3KxkpRIXprdTdblCl/fWxH6z+X9bEF7PjAR
Zy7xd8svClyGLaMp9+kZCsW9MKXkHAjs/nc1oetf6jcggxrIhpmfl58z9OCLwq7UafH56J4PnQfx
kVNJw9p0AZO6+E8OrFuSgCMWv69bxCaJ9Kth5rLvE9TFSMGBnqTRcCE72QHGIHE9di1OCoX++cwO
nfDDlNblq67KrBbA5q0wsmwmIWedzT59LodWO40OSu1vCoypQ5qJqbq6Y/Ii7VnLjP84osyZy69g
nxnFv76DimHHMvpf/sTtH647MLXUW5TIDGr9OT53Oyslg8cHpkLqMIIHbTCCBVWgAwIBAgIQFxA+
3j2KHLXKBlGT58pDazANBgkqhkiG9w0BAQsFADBrMQswCQYDVQQGEwJJVDEOMAwGA1UEBwwFTWls
YW4xIzAhBgNVBAoMGkFjdGFsaXMgUy5wLkEuLzAzMzU4NTIwOTY3MScwJQYDVQQDDB5BY3RhbGlz
IEF1dGhlbnRpY2F0aW9uIFJvb3QgQ0EwHhcNMjAwNzA2MDg0NTQ3WhcNMzAwOTIyMTEyMjAyWjCB
gTELMAkGA1UEBhMCSVQxEDAOBgNVBAgMB0JlcmdhbW8xGTAXBgNVBAcMEFBvbnRlIFNhbiBQaWV0
cm8xFzAVBgNVBAoMDkFjdGFsaXMgUy5wLkEuMSwwKgYDVQQDDCNBY3RhbGlzIENsaWVudCBBdXRo
ZW50aWNhdGlvbiBDQSBHMzCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAO3mh5ahwaS2
7cJCVfc/Dw8iYF8T4KZDiIZJkXkcGy8aUA/cRgHu9ro6hsxRYe/ED4AIcSlarRh82HqtFSVQs4Zw
ikQW1V/icCIS91C2IVAGa1YlKfedqgweqky+bBniUvRevVT0keZOqRTcO5hw007dL6FhYNmlZBt5
IaJs1V6IniRjokOHR++qWgrUGy5LefY6ACs9gZ8Bi0OMK9PZ37pibeQCsdmMRytl4Ej7JVWeM/Bt
NIIprHwO1LY0/8InpGOmdG+5LC6xHLzg53B0HvVUqzUQNePUhNwJZFmmTP46FXovxmH4/SuY5IkX
op0eJqjN+dxRHHizngYUk1EaTHUOcLFy4vQ0kxgbjb+GsNg6M2/6gZZIRk78JPdpotIwHnBNtkp9
wPVH61NqdcP7kbPkyLXkNMTtAfydpmNnGqqHLEvUrK4iBpUPG9C09KOjm9OyhrT2uf5SLzJsee9g
79r/rw4hAgcsZtR3YI6fCbROJncmD+hgbHCck+9TWcNc1x5xZMgm8UXmoPamkkfceAlVV49QQ5jU
TgqneTQHyF1F2ExXmf47pEIoJMVxloRIXywQuB2uqcIs8/X6tfsMDynFmhfT/0mTrgQ6xt9DIsgm
WuuhvZhLReWS7oeKxnyqscuGeTMXnLs7fjGZq0inyhnlznhA/4rl+WdNjNaO4jEvAgMBAAGjggH0
MIIB8DAPBgNVHRMBAf8EBTADAQH/MB8GA1UdIwQYMBaAFFLYiDrIn3hm7YnzezhwlMkCAjbQMEEG
CCsGAQUFBwEBBDUwMzAxBggrBgEFBQcwAYYlaHR0cDovL29jc3AwNS5hY3RhbGlzLml0L1ZBL0FV
VEgtUk9PVDBFBgNVHSAEPjA8MDoGBFUdIAAwMjAwBggrBgEFBQcCARYkaHR0cHM6Ly93d3cuYWN0
YWxpcy5pdC9hcmVhLWRvd25sb2FkMB0GA1UdJQQWMBQGCCsGAQUFBwMCBggrBgEFBQcDBDCB4wYD
VR0fBIHbMIHYMIGWoIGToIGQhoGNbGRhcDovL2xkYXAwNS5hY3RhbGlzLml0L2NuJTNkQWN0YWxp
cyUyMEF1dGhlbnRpY2F0aW9uJTIwUm9vdCUyMENBLG8lM2RBY3RhbGlzJTIwUy5wLkEuJTJmMDMz
NTg1MjA5NjcsYyUzZElUP2NlcnRpZmljYXRlUmV2b2NhdGlvbkxpc3Q7YmluYXJ5MD2gO6A5hjdo
dHRwOi8vY3JsMDUuYWN0YWxpcy5pdC9SZXBvc2l0b3J5L0FVVEgtUk9PVC9nZXRMYXN0Q1JMMB0G
A1UdDgQWBBS+l6mqhL+AvxBTfQky+eEuMhvPdzAOBgNVHQ8BAf8EBAMCAQYwDQYJKoZIhvcNAQEL
BQADggIBACab5xtZDXSzEgPp51X3hICFzULDO2EcV8em5hLfSCKxZR9amCnjcODVfMbaKfdUZXte
vMIIZmHgkz9dBan7ijGbJXjZCPP29zwZGSyCjpfadg5s9hnNCN1r3DGwIHfyLgbcfffDyV/2wW+X
TGbhldnazZsX892q+srRmC8XnX4ygg+eWL/AkHDenvbFuTlJvUyd5I7e1nb3dYXMObPu24ZTQ9/K
1hSQbs7pqecaptTUjoIDpBUpSp4Us+h1I4MAWonemKYoPS9f0y65JrRCKcfsKSI+1kwPSanDDMiy
dKzeo46XrS0hlA5NzQjqUJ7UsuGvPtDvknqc0v03nNXBnUjejYtvwO3sEDXdUW5m9kjNqlQZXzdH
umZJVqPUGKTWcn9Hf3d7qbCmmxPXjQoNUuHg56fLCanZWkEO4SP1GAgIA7SyJu/yffv0ts7sBFrS
TD3L2mCAXM3Y8BfblvvDSf2bvySm/fPe9brmuzrCXsTxUQc1+/z5ydvzV3E3cLnUoSXP6XfXNyEV
O6sPkcUSnISHM798xLkCTB5EkjPCjPE2zs4v9L9JVOkkskvW6RnWWccdfR3fELNHL/kep8re6Ibb
Ys8Hn5GM0Ohs8CMDPYEox+QX/6/SnOfyaqqSilBonMQBstsymBBgdEKO+tTHHCMnJQVvZn7jRQ20
wXgxMrvNMYIDhTCCA4ECAQEwgZYwgYExCzAJBgNVBAYTAklUMRAwDgYDVQQIDAdCZXJnYW1vMRkw
FwYDVQQHDBBQb250ZSBTYW4gUGlldHJvMRcwFQYDVQQKDA5BY3RhbGlzIFMucC5BLjEsMCoGA1UE
AwwjQWN0YWxpcyBDbGllbnQgQXV0aGVudGljYXRpb24gQ0EgRzMCEHFKJRdYWMzu/EMoDoK39Ngw
DQYJYIZIAWUDBAIBBQCgggG/MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTI0MDEwNzEyMzc0OVowLwYJKoZIhvcNAQkEMSIEIGe4wCjC2Tn6FYmUdg/ztHFFcrXRtA3T
RsTK5f0LD3+JMIGnBgkrBgEEAYI3EAQxgZkwgZYwgYExCzAJBgNVBAYTAklUMRAwDgYDVQQIDAdC
ZXJnYW1vMRkwFwYDVQQHDBBQb250ZSBTYW4gUGlldHJvMRcwFQYDVQQKDA5BY3RhbGlzIFMucC5B
LjEsMCoGA1UEAwwjQWN0YWxpcyBDbGllbnQgQXV0aGVudGljYXRpb24gQ0EgRzMCEHFKJRdYWMzu
/EMoDoK39NgwgakGCyqGSIb3DQEJEAILMYGZoIGWMIGBMQswCQYDVQQGEwJJVDEQMA4GA1UECAwH
QmVyZ2FtbzEZMBcGA1UEBwwQUG9udGUgU2FuIFBpZXRybzEXMBUGA1UECgwOQWN0YWxpcyBTLnAu
QS4xLDAqBgNVBAMMI0FjdGFsaXMgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIENBIEczAhBxSiUXWFjM
7vxDKA6Ct/TYMA0GCSqGSIb3DQEBAQUABIIBAAwvP2HjkhgHOHJGRgZ56/AlVhJWd5xkzl5Fmz9g
jbVm0AJOggtBZPERNWfkYOOGSUK6NUtuYf62nVkvyOGUGl/ioGwnDrZ5q3e55z/wlvzKU8utaEE2
7hZmgS8zITjvp2UsoX/jHbZszg9NYurLOK65hnfes/CDj5Dl8NMdlQcIHWkNYVkWPkwYGSKV+o1l
5OZQ7ATFq8yepGwOi8xgEtWE5ZM79QcZrVHlx620/04rXfNQMkIItP0z5P3Um3CqyBTAdZjCRu9b
ob2OIin9Zz0r7UjT0EV9Il5JSEjDZEkI6vivUvYm9d1ddyhgcDHYz6IhVRWMZzYwMKJrp5xm7LoA
AAAAAAA=


--=-GbovYzzkmtIQU+FqJwCO--
